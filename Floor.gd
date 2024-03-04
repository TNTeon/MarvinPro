extends MeshInstance3D

@onready var whiteField = load("res://whiteFieldBackground.png")
@onready var darkField = load("res://custom-centerstage-field-diagrams-works-with-meepmeep-v0-osvn5chufpob1.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material_override.albedo_texture = darkField


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		if self.material_override.albedo_texture == darkField:
			self.material_override.albedo_texture = whiteField
		else:
			self.material_override.albedo_texture = darkField
