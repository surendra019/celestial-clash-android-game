extends Area2D

var speed := 1000.0
var direction = Vector2.UP
var damage = 20

func _physics_process(delta):
	move(delta)
	check_pos()


	
func move(delta):
	if Manager.game_start:
		self.position += speed*delta*direction
func check_pos():
	if self.position.y > Manager.win_size.y or self.position.x> Manager.win_size.x or self.position.x< 0 or self.position.y< 0:
		self.queue_free()
	pass
