extends Camera3D

var PosA
var RotA
var orthoPos = Vector3(0,10,0)
var orthoRot = Vector3(-3.14/2,0,0)
var t = 1
var currentPersective = true
var justChanged = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.size = 15

func _process(delta):
	print(self.global_position)
	if currentPersective != global.camPerspective:
		if currentPersective:
			PosA = self.global_position
			RotA = self.global_rotation
		currentPersective = global.camPerspective
		t = 0
	if t < 1 and !currentPersective:
		self.global_position = PosA.lerp(orthoPos,t)
		self.global_rotation = RotA.lerp(orthoRot,t)
		t += delta * 0.8
	elif t >= 1 and !currentPersective:
		self.projection = Camera3D.PROJECTION_ORTHOGONAL
	elif t < 1 and currentPersective:
		self.projection = Camera3D.PROJECTION_PERSPECTIVE
		self.global_position = orthoPos.lerp(PosA,t)
		self.global_rotation = orthoRot.lerp(RotA,t)
		t += delta * 0.8
