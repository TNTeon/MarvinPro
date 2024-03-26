extends MeshInstance3D

@onready var ghostBlock = $"../../../ghostBox"
@onready var curve = $"../.."
@onready var fullCurve = $"../../../Path3D"

var progress
var pathSection

var showingPreview = false

var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	progress = 0
	visible = false
	pathSection = 0
	curve = curve.curve
	fullCurve = fullCurve.curve
	
	global.previewBot = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var curveLength = curve.get_baked_length()
	if curveLength != 0:
		speed = global.speedSlider/curveLength
	else:
		speed = 0
	global.isPreviewing = showingPreview
	if Input.is_action_just_pressed("ui_q") and len(global.botOrder) >= 2:
		if showingPreview:
			self.visible = false
			showingPreview = false
			global.hoveringGUI = false
			pathSection = 0
		else:
			self.scale = ghostBlock.scale
			self.visible = true
			progress = 0
			showingPreview = true
			
	if showingPreview:
		if len(global.botOrder) < 2:
			showingPreview = false
			self.visible = false
		else:
			global.hoveringGUI = true
			
		
		progress += speed * delta
		self.position.y = ghostBlock.scale.y/2
		
		if len(global.botOrder) > 1:
			curve.clear_points()
			if progress >=0.999:
				if pathSection != len(global.botOrder)-2:
					pathSection += 1
				else:
					pathSection = 0
				progress = 0
			curve.add_point(fullCurve.get_point_position(pathSection),fullCurve.get_point_in(pathSection), fullCurve.get_point_out(pathSection))
			curve.add_point(fullCurve.get_point_position(pathSection+1),fullCurve.get_point_in(pathSection+1), fullCurve.get_point_out(pathSection+1))
			
			var currentBotRotation = fmod(global.botOrder[pathSection].rotation.y,TAU)
			currentBotRotation = fmod((currentBotRotation + TAU), TAU)
			var secondBotRotation = fmod(global.botOrder[pathSection+1].rotation.y,TAU)
			secondBotRotation = fmod((secondBotRotation + TAU), TAU)
			
			if (currentBotRotation > PI):
				currentBotRotation -= TAU
			if (secondBotRotation > PI):
				secondBotRotation -= TAU
			
			var dx0 = 5
			var dx1 = -5
			
			var a = 2 * currentBotRotation + dx0 - 2 * secondBotRotation + dx1
			var b = -3 * currentBotRotation - 2 * dx0 + 3 * secondBotRotation - dx1
			var c = dx0
			var d = currentBotRotation
			
			var setRot = (a * pow(progress,3)) + (b * pow(progress,2)) + (c * progress) + d
			
			self.rotation.y = setRot
			
			get_parent().progress_ratio = progress
func stopPreview():
	self.visible = false
	showingPreview = false
	global.hoveringGUI = false
	pathSection = 0
