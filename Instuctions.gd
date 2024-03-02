extends Control

func _ready():
	find_child("CanvasLayer").find_child("Panel").visible = true
	$AnimationPlayer.play("start")

func _input(event):
	if event is InputEventKey:
		if event.keycode == 4194305 and event.pressed:
			if find_child("CanvasLayer").find_child("Panel").visible == true:
				$AnimationPlayer.play("FoldInSettings")
			else:
				$AnimationPlayer.play("FoldOutSettings")
				find_child("CanvasLayer").find_child("Panel").visible = true
		

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FoldInSettings":
		global.hoveringGUI = false
		

func _process(delta):
	if find_child("CanvasLayer").find_child("Panel").visible:
		global.hoveringGUI = true
		
