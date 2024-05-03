extends MeshInstance3D

@onready var ghostBlock = $"../../../ghostBox"
@onready var curve = $"../.."
@onready var fullCurve = $"../../../Path3D"
@onready var tanBot = $"../../PathFollow3D2/MovingBot"

var progress
var pathSection

var showingPreview = false

var speed = 1

var lastVel = 0
var lastDX1 = 0

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
			print(pathSection)
			curve.clear_points()
			if progress >=0.999:
				if pathSection != len(global.botOrder)-2:
					pathSection += 1
				else:
					pathSection = 0
				progress = 0
			curve.add_point(fullCurve.get_point_position(pathSection),fullCurve.get_point_in(pathSection), fullCurve.get_point_out(pathSection))
			curve.add_point(fullCurve.get_point_position(pathSection+1),fullCurve.get_point_in(pathSection+1), fullCurve.get_point_out(pathSection+1))
			
			var tanAngleStart = atan2(fullCurve.get_point_out(pathSection).x,fullCurve.get_point_out(pathSection).z)
			tanAngleStart -= PI
			tanAngleStart = fmod(tanAngleStart,TAU)
			tanAngleStart = fmod((tanAngleStart + TAU), TAU)
			if (tanAngleStart > PI):
				tanAngleStart -= TAU
			
			var tanAngleEnd = atan2(fullCurve.get_point_in(pathSection+1).x,fullCurve.get_point_in(pathSection+1).z)
			tanAngleEnd -= TAU
			tanAngleEnd = fmod(tanAngleEnd,TAU)
			tanAngleEnd = fmod((tanAngleEnd + TAU), TAU)
			if (tanAngleEnd > PI):
				tanAngleEnd -= TAU
			
			var currentBotRotation = fmod(global.botOrder[pathSection].rotation.y,TAU)
			currentBotRotation = fmod((currentBotRotation + TAU), TAU)
			var secondBotRotation = fmod(global.botOrder[pathSection+1].rotation.y,TAU)
			secondBotRotation = fmod((secondBotRotation + TAU), TAU)
			
			if (currentBotRotation > PI):
				currentBotRotation -= TAU
			if (secondBotRotation > PI):
				secondBotRotation -= TAU
			
			var dx0
			if pathSection == 0:
				dx0 = (getTanAngle(0.005,tanAngleStart) - tanAngleStart)*500
			else:
				dx0 = lastVel
			var dx1 = (tanAngleEnd - getTanAngle(0.995,tanAngleEnd))*500
			if lastDX1 != dx1:
				lastVel = lastDX1
				lastDX1 = dx1
			
			dx0 = clamp(dx0, -10, 10)
			dx1 = clamp(dx1, -10, 10)
			print("DX0 ",dx0)
			print("DX1 ",dx1)
			print("lastVel ",lastVel)
			
			var interpType = global.botOrder[pathSection].get_meta("interpType")
			if interpType == "linear":
				dx0 = 0
				dx1 = 0
			
			
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

func getTanAngle(pos, ref):
	$"../../PathFollow3D2".progress_ratio = pos
	$"../../PathFollow3D2".rotation.y -= (PI/2)
	var newRot = $"../../PathFollow3D2".rotation.y
	
	newRot -= PI/2
	newRot = fmod(newRot,TAU)
	newRot = fmod((newRot + TAU), TAU)
	if (newRot > PI):
		newRot -= TAU
	if abs((newRot + TAU)-ref) < abs(newRot-ref):
		newRot += TAU
	if abs((newRot - TAU)-ref) < abs(newRot-ref):
		newRot -= TAU
	return newRot
