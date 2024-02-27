extends Node3D

var startRotating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_mouse_right") or Input.is_action_just_pressed("ui_mouse_left")) and global.currentObj.get_parent() == self:
		startRotating = true
	if startRotating:
		var tempPos = global.currentMousePos
		tempPos.y = self.global_position.y
		self.look_at(Vector3(tempPos), Vector3(0,1,0))
		if Input.is_action_pressed("ui_shift"):
			self.rotation.y = snapped(self.rotation.y,PI/8)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		startRotating = false
