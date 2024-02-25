extends CharacterBody3D


const SPEED = 5.0

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

#Get mouse movement for camera only if control is held
func _unhandled_input(event):
	if Input.is_action_pressed("ui_control") and global.camPerspective == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and global.camPerspective == true:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x*0.001)
			camera.rotate_x(-event.relative.y*0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

# Move character, Space/Shift for up and down, wasd
func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and global.camPerspective == true:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("ui_space") and !Input.is_action_pressed("ui_shift"):
			velocity.y = 1 * SPEED
		elif Input.is_action_pressed("ui_shift") and !Input.is_action_pressed("ui_space"):
			velocity.y = -1 * SPEED
		else:
			velocity.y = 0
			
		move_and_slide()
			
	if Input.is_action_just_pressed("ui_o"):
		global.camPerspective = false
	elif Input.is_action_just_pressed("ui_p"):
		global.camPerspective = true
