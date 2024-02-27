extends MeshInstance3D

@onready var ghostBlock = $"../../../ghostBox"

var progress

# Called when the node enters the scene tree for the first time.
func _ready():
	progress = 0
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_q"):
		self.scale = ghostBlock.scale
		self.visible = true
		progress = 0
	if Input.is_action_just_released("ui_q"):
		self.visible = false
	progress += 0.3 * delta
	self.position.y = ghostBlock.scale.y/2
	get_parent().progress_ratio = progress
	
	if len(global.botOrder) > 1:
		var currentRot = int(get_parent().progress_ratio/(1.0/(len(global.botOrder)-1)))
		if currentRot+1 != len(global.botOrder):
			var currentBotRotY = global.botOrder[currentRot].rotation.y
			var currentBotSecondRotY = global.botOrder[currentRot+1].rotation.y
			if abs(currentBotRotY-currentBotSecondRotY) < abs (currentBotRotY - (global.botOrder[currentRot+1].rotation.y-2*PI)):
				self.rotation.y = lerp(currentBotRotY,currentBotSecondRotY,(get_parent().progress_ratio*(len(global.botOrder)-1))-int(get_parent().progress_ratio*(len(global.botOrder)-1)))
			else:
				self.rotation.y = lerp(currentBotRotY,global.botOrder[currentRot+1].rotation.y - 2*PI,(get_parent().progress_ratio*(len(global.botOrder)-1))-int(get_parent().progress_ratio*(len(global.botOrder)-1)))
