extends Area2D

signal main_killed
var speed = 50.0
var health 
@onready var progress_bar = get_node("ProgressBar")
var score_label
var in_game
var player
var electro_ball_time
var electro_ball_speed
var electro_ball_anim_speed_scale

@onready var ball = preload("res://Scenes/electro_ball.tscn")
@onready var ball_timer = get_node("Timer")

func _ready():

	progress_bar.visible = false
	progress_bar.max_value =  health
	progress_bar.value = progress_bar.max_value
	if get_tree().has_group("score_label"):
		score_label = get_tree().get_nodes_in_group("score_label")[0]
	if get_tree().has_group("in_game"):
		in_game = get_tree().get_nodes_in_group("in_game")[0]
	player = in_game.player
	Manager.connect("main_reached_signal", start_firing_timer)

func check_health():
	if Manager.game_start:
		if progress_bar.value == 0:
			Manager.set_main_enemy_var()
			Manager.set_further_score_enabled = true
			var twn = create_tween()
			twn.tween_property(self, "scale", Vector2(0, 0), .1)
			twn.tween_callback(self.queue_free)
			twn.play()
			twn.finished.connect(on_self_destroyed)
			
func on_self_destroyed():
	Manager.update_score(500,score_label)
	
func _physics_process(delta):
	if Manager.game_start:
		check_health()
		detect_bullet()
		if Manager.main_reached== false:
			self.position.y+=speed*delta
		if self.position.y >= Manager.win_size.y/3 and not Manager.main_reached:
			Manager.on_main_reached()
			
func detect_bullet():
	var overlapping_areas = self.get_overlapping_areas()
	if Manager.main_reached:
		for i in overlapping_areas:
			if i.is_in_group("bullet"):
				progress_bar.visible = true
				progress_bar.value-=i.damage
				i.queue_free()
				

func start_firing_timer():
	if Manager.game_start:
	#	print("timer_started")
		ball_timer.wait_time = electro_ball_time
		ball_timer.start()
		ball_timer.timeout.connect(make_ball)
	
	
func make_ball():
	var b= ball.instantiate()
	add_child(b)
	
	var ball_anim = b.get_child(0)
	ball_anim.set_frame(0)
	var twn = create_tween()
	twn.tween_property(b, "visible", true, 2)
	twn.play()
	ball_anim.play()
	ball_anim.animation_finished.connect(fire_ball.bind(b))


func fire_ball(b):
	var player_pos = player.global_position
	var final_pos =(player_pos-b.global_position)+player_pos
	var twn =create_tween()
	twn.tween_property(b, "global_position",final_pos, electro_ball_speed)
	twn.play()
	twn.finished.connect(reset_timer)

func reset_timer():
	if Manager.game_start:
		ball_timer.start()
	
