extends Label3D

func _ready():
	self.rotation = Vector3(-90,0,0)

func _process(delta):
	self.position = get_parent().position
	self.position.y = get_parent().scale.y
	self.text = str(global.botOrder.find(get_parent())+1)
