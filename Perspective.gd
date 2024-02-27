extends Camera3D

@onready var ghostBox = $"../../../ghostBox"
@onready var floorStatic = $"../../../Floor/StaticBody3D"
const botScene = preload("res://bot.tscn")

var PosA
var RotA
var orthoPos = Vector3(0,10,0)
var orthoRot = Vector3(-3.14/2,0,0)
var t = 1
var currentPersective = true
var justChanged = false

var mouseHeld = false

@onready var field = $"../../../Field"


func _ready():
	self.size = 15
	global.camera = self

#Switch between Perspective and orthographic views
func _process(delta):
	
	ghostBox.scale = global.botDimentions/12
	
	if !Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		placeBox()
	else:
		ghostBox.visible = false
		
	if currentPersective != global.camPerspective:
		if currentPersective:
			PosA = self.global_position
			RotA = self.global_rotation
		currentPersective = global.camPerspective
		t = 0
	if t < 1 and !currentPersective:
		self.global_position = PosA.lerp(orthoPos,t)
		self.global_rotation = RotA.lerp(orthoRot,t)
		t += delta * 0.8
	elif t >= 1 and !currentPersective:
		self.projection = Camera3D.PROJECTION_ORTHOGONAL
		field.visible = false
	elif t < 1 and currentPersective:
		field.visible = true
		self.projection = Camera3D.PROJECTION_PERSPECTIVE
		self.global_position = orthoPos.lerp(PosA,t)
		self.global_rotation = orthoRot.lerp(RotA,t)
		t += delta * 0.8

func placeBox():
	
	var spacestate = get_world_3d().direct_space_state
	
	var mousePos = get_viewport().get_mouse_position()
	var camera = self
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var rayArrary = spacestate.intersect_ray(query)
	
	if rayArrary.has("position") and rayArrary["collider"] == floorStatic:
			ghostBox.visible = true
			if Input.is_action_pressed("ui_shift"):
				var newPos = (rayArrary["position"] + Vector3(0,ghostBox.scale.y/2,0))
				ghostBox.position.x = snapped(newPos.x,1)
				ghostBox.position.y = newPos.y
				ghostBox.position.z = snapped(newPos.z,1)
			else:
				ghostBox.position = rayArrary["position"] + Vector3(0,ghostBox.scale.y/2,0)
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if !mouseHeld:
					var instanceBot = botScene.instantiate()
					instanceBot.position = ghostBox.position
					get_tree().get_root().add_child(instanceBot)
			else:
				mouseHeld = false
	else:
		ghostBox.visible = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !mouseHeld:
			mouseHeld = true
	else:
		mouseHeld = false
