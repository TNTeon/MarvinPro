extends MeshInstance3D

@onready var ghostBlock = $"../../../ghostBox"
@onready var curve = $"../.."
@onready var fullCurve = $"../../../Path3D"
@onready var tanBot = $"../../PathFollow3D2/MovingBot"

var progress
var pathSection

var showingPreview = false

var speed = 1

var currentCurve : Curve3D

# Called when the node enters the scene tree for the first time.
func _ready():
	progress = 0
	visible = false
	pathSection = 0
	curve = curve.curve
	currentCurve = curve
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
			
			var P0x = currentCurve.get_point_position(0).x
			var P1x = P0x +currentCurve.get_point_out(0).x
			var P3x = currentCurve.get_point_position(1).x
			var P2x = P3x + currentCurve.get_point_in(1).x
			
			var P0y = currentCurve.get_point_position(0).z
			var P1y = P0y +currentCurve.get_point_out(0).z
			var P3y = currentCurve.get_point_position(1).z
			var P2y = P3y + currentCurve.get_point_in(1).z
			
			var a = 0
			var b = (splineD(P0x,P1x,P2x,P3x,0) * splineDD(P0y,P1y,P2y,P3y,0) - splineD(P0y,P1y,P2y,P3y,0) * splineD(P0x,P1x,P2x,P3x,0))*curveLength
			var c = (splineD(P0x,P1x,P2x,P3x,0) * splineDDD(P0y,P1y,P2y,P3y,0) - splineD(P0y,P1y,P2y,P3y,0) * splineDDD(P0x,P1x,P2x,P3x,0))*curveLength
			var d = 0
			var e = (splineD(P0x,P1x,P2x,P3x,1) * splineDD(P0y,P1y,P2y,P3y,1) - splineD(P0y,P1y,P2y,P3y,1) * splineD(P0x,P1x,P2x,P3x,1))*curveLength
			var f = (splineD(P0x,P1x,P2x,P3x,1) * splineDDD(P0y,P1y,P2y,P3y,1) - splineD(P0y,P1y,P2y,P3y,1) * splineDDD(P0x,P1x,P2x,P3x,1))*curveLength
			
			var a1 = 0.05*f-0.6*(-0.25*f+e)+6*(0.05*f-0.4*e+d)-0.5*c-3*b-6*a
			var b1 = -0.25*f+e-15*(0.05*f-0.4*e+d)+1.5*c+8*b+15*a
			var c1 = 10*(0.05*f-0.4*e+d)-1.5*c-6*b-10*a
			var d1 = 0.5*c
			var e1 = b
			var f1 = a
			
			var heading = pow(progress,5)*a1 + pow(progress,4)*b1 + pow(progress,3)*c1 + pow(progress,2)*d1 + progress*e1 + f1
			heading = deg_to_rad(heading)
			
			var interpType = global.botOrder[pathSection].get_meta("interpType")
			if interpType == "linear":
				pass
			self.rotation.y = heading
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

func splinePos(P0,P1,P2,P3,t):
	return P0 + (t*(-3*P0+3*P1)) + (pow(t,2)*(3*P0-6*P1+3*P2)) + (pow(t,3)*(-P0+3*P1-3*P2+P3))
func splineD(P0,P1,P2,P3,t):
	return ((-3*P0+3*P1)) + (2*t*(3*P0-6*P1+3*P2)) + (3*pow(t,2)*(-P0+3*P1-3*P2+P3))
func splineDD(P0,P1,P2,P3,t):
	return (2*(3*P0-6*P1+3*P2)) + (6*t*(-P0+3*P1-3*P2+P3))
func splineDDD(P0,P1,P2,P3,t):
	return (6*(-P0+3*P1-3*P2+P3))
