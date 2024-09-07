extends CharacterBody2D

var speed := 20000.0
var space_ship_control
@onready var sprite = get_node("Sprite2D")
var objects
var bullet = preload("res://Scenes/bullet1.tscn")
@onready var ship_touch  = get_node("TouchScreenButton")
var counter = 0
var multiple_bull_t_progress
var dirn = Vector2.ZERO
var player_health

var initial_points = []
var sound_man

var in_game
var ast = preload("res://Scenes/asteroid1.tscn")

var fire_enabled = true
var asteroids
var bullet_time = 0.2

func _ready():
	set_initial_points()
	if get_tree().has_group("asteroid_group"):
		asteroids = get_tree().get_nodes_in_group("asteroid_group")[0]
	asteroids.global_position = Manager.win_size/2
	if get_tree().has_group("space_ship_control"):
		space_ship_control = get_tree().get_nodes_in_group("space_ship_control")[0]
	if get_tree().has_group("player_health"):
		player_health = get_tree().get_nodes_in_group("player_health")[0]
		player_health.value_changed.connect(check_health)
	if get_tree().has_group("objects"):
		objects = get_tree().get_nodes_in_group("objects")[0]
	if get_tree().has_group("multiple_bull_t_progress"):
		multiple_bull_t_progress= get_tree().get_nodes_in_group("multiple_bull_t_progress")[0]
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]
	if get_tree().has_group("in_game"):
		in_game = get_tree().get_nodes_in_group("in_game")[0]

func check_health(health):
	if health == 0:
		Manager.set_panel(in_game.game_over, "show", in_game)
		Input.vibrate_handheld()

func _physics_process(delta):
	
	if Manager.game_start:
		fire(delta)

		if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TOUCH:
			move_ship(delta)
		elif Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TILT:
			tilt_ship(delta)
		
		counter+=delta
		if Manager.main_coming:
			fire_enabled = false
		if Manager.main_reached:
			fire_enabled = true
	
		detect_electro_ball()
		move_and_slide()
		

func tilt_ship(delta):
	velocity = Vector2(Input.get_gyroscope().y, 0)*speed*delta


func move_ship(delta):
	velocity = dirn*speed*delta
	if space_ship_control.get_node("touch/Left").is_pressed() or Input.is_action_pressed("ui_left"):
		dirn = Vector2.LEFT
	elif space_ship_control.get_node("touch/Right").is_pressed() or Input.is_action_pressed("ui_right"):
		dirn = Vector2.RIGHT
	else:
		dirn.x = lerp(dirn.x, 0.0, 0.1)
		dirn.y = lerp(dirn.y, 0.0, 0.1)
	
func fire(delta):
	if fire_enabled:
		if counter> bullet_time and Manager.game_start:
			if sound_man!=null:
				sound_man.play_bullet_fire()
			var bullet_ins = bullet.instantiate()
			
			bullet_ins.global_position = $Marker2D.global_position
			objects.add_child(bullet_ins)
			counter = 0
	pass


func asteroid(touch_btn):
	Manager.status_update("asteroids activated!")
	touch_btn.get_parent().value = 0
	touch_btn.visible = false
	set_asteroids()
	pass
func set_asteroids():
	for i in range(1, 4):
		var a = ast.instantiate()
		a.global_position = initial_points.pick_random()
		a.rotation_degrees = randi_range(0, 90)
		var rand_scale = randf_range(.1, .4)
		a.scale.x = rand_scale
		a.scale.y = rand_scale
		a.modulate = Color(0,1,1, .7)
		a.speed = 5.0
		a.angle = i*90
		asteroids.add_child(a)
		animate_asteroids(a)
	

func animate_asteroids(a):
	var twn = create_tween()
	twn.tween_property(a, "global_position", asteroids.global_position, 1)
	twn.set_ease(Tween.EASE_OUT)
	twn.play()
	twn.finished.connect(rotate_asteroids.bind(a))

func rotate_asteroids(a):
	a.rotate = true
	pass

func set_cross_bullets(touch_btn):
	Manager.status_update("multiple bullets activated!")
	var bull = 31
	var div = 90/((bull-1)/2)
	multiple_bull_t_progress.value = 0
	touch_btn.visible = false
	for i in range(0, bull):
		var b = bullet.instantiate()
		b.damage+=30
		b.scale *=2
		
		cross_bullets_ins(b, i*div)
	
func cross_bullets_ins(obj, deg):
	var rot = deg_to_rad(deg)
	var dirn = Vector2(cos(rot), sin(rot))
	
	obj.direction = -dirn
	obj.rotation = rot-deg_to_rad(90)
	obj.global_position = self.global_position
	objects.add_child(obj)

func detect_electro_ball():
	if Manager.game_start:
		if Manager.main_reached:
			var main_enemy = in_game.main_enemy_instance
			var obj = $Area2D.get_overlapping_areas()
			for body in obj:
				if body.is_in_group("electro_ball"):
					body.queue_free()
					decrease_health(30)
					main_enemy.reset_timer()

func decrease_health(val):
	Manager.sound_man.play_dmg_sound()
	var twn = create_tween()
	twn.tween_property(player_health, "value", player_health.value-val, .7)
	twn.set_ease(Tween.EASE_OUT)
	for i in range(1, 4):
		self.get_child(0).self_modulate = Color(1,0,0.8)
		await get_tree().create_timer(.5).timeout
		self.get_child(0).self_modulate = Color(1,1,1,1)
		await get_tree().create_timer(.3).timeout
	twn.play()


func set_initial_points():
	for vertical in range(-300, Manager.win_size.y+200):
		initial_points.push_back(Vector2(-300,vertical))
		initial_points.push_back(Vector2(Manager.win_size.x+300, vertical))
	for horizontal in range(-300, Manager.win_size.x+300):
		initial_points.push_back(Vector2(horizontal, -300))
		initial_points.push_back(Vector2(horizontal, Manager.win_size.y+300))



func _on_control_gui_input(event):
#	print(Manager.space_ship_control)
	if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.SLIDE:
		if event is InputEventScreenDrag:
			print(event.position+self.position)
#			self.position = event.position
	pass # Replace with function body.


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenDrag:
		self.global_position.x=event.position.x
	pass # Replace with function body.
