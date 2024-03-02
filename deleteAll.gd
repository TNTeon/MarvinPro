extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_r") and !global.hoveringGUI:
		self.visible = true
	if self.visible == true:	
		global.hoveringGUI = true
	

func _on_yes_delete_but_pressed():
	global.botOrder.clear()
	global.invisBots = false
	self.visible = false
	global.hoveringGUI = false



func _on_no_keep_but_pressed():
	self.visible = false
	global.hoveringGUI = false
