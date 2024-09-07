extends Area2D

var speed = 20.0
var direction : Vector2
var dirn_specified = false
var final_point: Vector2
var rotate = false

var ast_radius  = 100
var angle


func _ready():
#	Manager.set_speed_for_normal(self)
	pass
	
func _physics_process(delta):
	if dirn_specified and rotate == false:
		self.position+=direction*speed*delta
	if rotate and angle !=null:
		angle+=delta*speed
		pass

func _process(delta):
	if rotate and angle!=null:
		var x = ast_radius*cos(angle)
		var y = ast_radius*sin(angle)
		
		self.position = Vector2(x, y)
