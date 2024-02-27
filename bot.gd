extends MeshInstance3D

var orderCreated

@export var gradient: Gradient
var newMat;
var firstClick = true
var startRotating = false
var startMoving = false

var listBotScene = load("res://list_bot.tscn")
@onready var listBotContainer = $"/root/Node3D/settings/CanvasLayer/ScrollContainer/botListContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	orderCreated = global.numBotsCreated
	global.numBotsCreated += 1
	global.botOrder.append(self)
	self.mesh.material.albedo_color = gradient.sample(1.0/len(global.botOrder))
	
	var instance = listBotScene.instantiate()
	instance.set_meta("conntectedBot", get_path())
	listBotContainer.add_child(instance)
	

func _process(delta):
	
	self.scale = global.botDimentions/12
	self.position.y = global.botDimentions.y/24
	
	var selfPosInList = global.botOrder.find(self)
	if selfPosInList != 0:
		var dist = self.global_position.distance_to(global.botOrder[selfPosInList-1].global_position)
		self.find_child("TangentMover").find_child("ForwardTan").position.z = (1/self.scale.z)*dist*1.25
	if selfPosInList != len(global.botOrder)-1:
		var dist = self.global_position.distance_to(global.botOrder[selfPosInList+1].global_position)
		self.find_child("TangentMover").find_child("BackTan").position.z = -(1/self.scale.z)*dist*1.25
	
	if len(global.botOrder) > 1:
		self.mesh.material.albedo_color = gradient.sample((1.0/(global.numBotsCreated-1))*orderCreated)
	else:
		self.mesh.material.albedo_color = gradient.sample(0)
		
	if firstClick or startRotating:
		var tempPos = global.currentMousePos
		tempPos.y = self.position.y
		self.look_at(Vector3(tempPos), Vector3(0,1,0))
		if Input.is_action_pressed("ui_shift"):
			self.rotation.y = snapped(self.rotation.y,PI/8)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		firstClick = false
		startMoving = false
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		startRotating = false
	if Input.is_action_just_pressed("ui_mouse_right") and global.currentObj.get_parent() == self:
		startRotating = true
	if Input.is_action_just_pressed("ui_mouse_left") and global.currentObj.get_parent() == self:
		startMoving = true
	if startMoving:
		self.get_child(0).get_child(0).disabled = true
		var tempPos = global.currentMousePos
		tempPos.y = self.position.y
		self.position = tempPos
		if Input.is_action_pressed("ui_shift"):
			self.position.x = snapped(self.position.x,1)
			self.position.z = snapped(self.position.z,1)
	else:
		self.get_child(0).get_child(0).disabled = false
	
