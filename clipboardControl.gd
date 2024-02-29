extends Node

var animationPlayerFade

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var botList = []
	botList.append_array(global.botOrder)
	var clipBoardString
	if Input.is_action_just_pressed("ui_c") and len(botList) > 0 and !global.hoveringGUI:
		clipBoardString = ""
		print("copy")
		clipBoardString = "<REPLACE_WITH_SampleMecDrive>.setPoseEstimate(new Pose2d(" + str(snapped(-botList[0].position.z*12,0.001)) + "," + str(snapped(-botList[0].position.x*12,0.001)) + ", Math.toRadians(" + str(snapped(rad_to_deg(botList[0].rotation.y),0.01)) + ")));"
		clipBoardString += "\n"
		clipBoardString += "Trajectory <REPLACE_WITH_TRAJ_NAME> = <REPLACE_WITH_SampleMecDrive>.trajectoryBuilder(<REPLACE_WITH_SampleMecDrive>.getPoseEstimate(), Math.toRadians(" + str(snapped(rad_to_deg(botList[0].find_child("TangentMover").rotation.y),0.01)) + "))"
		clipBoardString += "\n"
		
		botList.remove_at(0)
		
		for bot in botList:
			clipBoardString += ".splineToSplineHeading(new Pose2d(" + str(snapped(-bot.position.z*12,0.001)) + "," + str(snapped(-bot.position.x*12,0.001)) + ", Math.toRadians(" + str(snapped(rad_to_deg(bot.rotation.y),0.01)) + ")), Math.toRadians(" + str(snapped(rad_to_deg(bot.find_child("TangentMover").rotation.y),0.01)) + "))" 
			clipBoardString += "\n"
			
		clipBoardString += ".build();"
		DisplayServer.clipboard_set(clipBoardString)
		animationPlayerFade.play("fade")
