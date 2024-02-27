extends Button

@onready var backBut = $backBut
@onready var forwardBut = $forwardBut
@onready var deleteBut = $deleteBut
var parent
var connectedBot

func _ready():
	visibleButtons(false)
	parent = get_parent()
	connectedBot = get_node(parent.get_meta("conntectedBot"))
	

func _on_pressed():
	visibleButtons(!backBut.visible)

func visibleButtons(areVisible):
	backBut.visible = areVisible
	forwardBut.visible = areVisible
	deleteBut.visible = areVisible
	
func _is_pos_in(checkpos:Vector2, gr):
	gr = gr.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y
func _input(event):
	if (event is InputEventMouseButton and not _is_pos_in(event.position,self) and Input.is_action_just_released("ui_mouse_left")) or event.is_action_pressed("ui_accept"):
		self.visible = false
		self.visible = true
		visibleButtons(false)

func _on_back_but_pressed():
	var tempPos = global.botOrder.find(connectedBot)
	global.botOrder.insert(tempPos-1, global.botOrder.pop_at(tempPos))
	
func _on_forward_but_pressed():
	var tempPos = global.botOrder.find(connectedBot)
	global.botOrder.insert(tempPos+1, global.botOrder.pop_at(tempPos))

func _on_delete_but_pressed():
	global.botOrder.remove_at(global.botOrder.find(connectedBot))
	connectedBot.queue_free()
	get_parent().queue_free()

func _process(delta):
	var new_stylebox_normal = self.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = connectedBot.mesh.material.albedo_color
	self.add_theme_stylebox_override("normal", new_stylebox_normal)
	
	parent.get_parent().move_child(parent, global.botOrder.find(connectedBot))
	var currentListPos = global.botOrder.find(connectedBot)
	if currentListPos == 0:
		backBut.visible = false
	if currentListPos == len(global.botOrder)-1:
		forwardBut.visible = false
		
