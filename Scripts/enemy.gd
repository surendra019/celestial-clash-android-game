extends Area2D

@export var speed := 100.0
@onready var progress_bar = get_node("ProgressBar")
var health = 100
var multiple_bull_t_progress
var asteroid_t_progress
var score_label
var damage = 10
var in_game


func _physics_process(delta):
	if Manager.game_start:
		self.position.y +=delta*speed
		detect_bullet()
		check_health()

func check_health():
	if Manager.game_start:
		if progress_bar.value == 0:
			var twn = self_destroy()
			twn.finished.connect(on_self_destroyed)

func self_destroy():
	var twn = create_tween()
	twn.tween_property(self, "scale", Vector2(0, 0), .1)
	twn.tween_callback(self.queue_free)
	twn.play()
	return twn
	

func on_self_destroyed():
	multiple_bull_t_progress.value+=30
	Manager.update_score(10,score_label)
	in_game.spawn_collectable(self.global_position)
	
func _ready():
#	Manager.set_speed(self)
	progress_bar.visible = false
	progress_bar.max_value = health
	progress_bar.value = health
	if get_tree().has_group("score_label"):
		score_label = get_tree().get_nodes_in_group("score_label")[0]
	if get_tree().has_group("in_game"):
		in_game = get_tree().get_nodes_in_group("in_game")[0]
	if get_tree().has_group("multiple_bull_t_progress"):
		multiple_bull_t_progress = get_tree().get_nodes_in_group("multiple_bull_t_progress")[0]
	if get_tree().has_group("asteroid_t_progress"):
		asteroid_t_progress = get_tree().get_nodes_in_group("asteroid_t_progress")[0]
		
func detect_bullet():
	var overlapping_areas = self.get_overlapping_areas()
	for i in overlapping_areas:
		if i.is_in_group("bullet"):
			progress_bar.visible = true
			progress_bar.value-=i.damage
			i.queue_free()
