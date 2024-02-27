extends CanvasLayer

func _process(delta):
	$WidthSelection.value = global.botDimentions.x
	$LengthSelection.value = global.botDimentions.z
	$HeightSelection.value = global.botDimentions.y
func _on_width_selection_value_changed(value):
	global.botDimentions.x = value


func _on_length_selection_value_changed(value):
	global.botDimentions.z = value


func _on_height_selection_value_changed(value):
	global.botDimentions.y = value
	
	
func _is_pos_in(checkpos:Vector2, gr):
	gr = gr.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y
func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position,$WidthSelection) or event.is_action_pressed("ui_accept"):
		$WidthSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$LengthSelection) or event.is_action_pressed("ui_accept"):
		$LengthSelection.get_line_edit().release_focus()
	if event is InputEventMouseButton and not _is_pos_in(event.position,$HeightSelection) or event.is_action_pressed("ui_accept"):
		$HeightSelection.get_line_edit().release_focus()
