extends Node2D

class_name controller

var space_ships
var player_node
var player = preload("res://Scenes/player.tscn").instantiate()

@onready var game_over = get_node("popups/game_over")
@onready var space_ship_control = get_node("space_ship_control")
var main_menu = ("res://Scenes/menu.tscn")
var xyz = "res://Scenes/player.tscn"
var left_touch
var right_touch
var objects
var wall

var popups
var restart_btn1

#enemy
var enemy_posn = []
var enemy_spawner
var enemy = preload("res://Scenes/enemy.tscn")
var main_enemy = preload("res://Scenes/Main_enemy.tscn")
var main_enemy_instance
var enemy_node

#in_game_settings
@onready var in_game_settings  = get_node("popups/in_game_settings")

#pause menu
@onready var pause_menu = get_node("popups/Control")
var menu_close_btn1
var restart_btn2
var resume_btn
var menu_btn
var settings_btn
var pause_btn

#on screen controls
var on_screen_controls
var power_ups_container
var fps_meter

#power ups
var multiple_bull_t_progress
var asteroid_t_progress
var shield_t_progress
var protection_enabled = false

var sound_man
var touches =[]


#for difficulty
var enemy_spawn_time = 1.2
var enemy_health = 100
var main_enemy_health = 2000
var main_electro_ball_time = 1
var main_electro_ball_speed 
var main_electro_ball_anim_speed_scale = 1.5

#scenes
var collectables_scene = preload("res://Scenes/collectables.tscn")
var enemy_emission_scene = preload("res://Scenes/enemy_emission.tscn")

#resources
var coin_texture = preload("res://Assets/icons/coin.png")
var multiplier_texture = preload("res://Assets/icons/multiplier.png")
var bullets_texture = preload("res://Assets/icons/bullets.png")

#nodes
@onready var collectables_container = $SpaceShips/Objects/collectables
@onready var shield_particle = $SpaceShips/effects/shield_particles

#tutorials

@onready var tilt_tutorial = get_node("tutorial/tilt_tutorial")
@onready var touch_tutorial = get_node("tutorial/touch_tutorial")
func _physics_process(delta):
	if Manager.game_start:
		fps_meter.text = "FPS : "+str(Engine.get_frames_per_second())
		detect_collision()

func on_main_reached():
	
	for i in Manager.touches:
		if i==pause_btn:
			continue
#		print(i.get_parent())
		i.get_parent().visible = true
	
func on_main_coming():
	Manager.main_coming = true
	for i in Manager.touches:
		if i==pause_btn:
			continue
#		print(i.get_parent())
		i.get_parent().visible = false
	
func _ready():

	space_ship_control.get_node("touch").visible = false
	Manager.in_game = self
	set_variables_for_difficulty()
	set_variables()
	add_player()
	connect_to_signals()
	set_control_anim()

	set_enemy_posn()
	set_space_ship_control()

	pause_menu.visible = false
	game_over.visible = false
	Manager.game_start = true
	
func set_control_anim():
	if ! Manager.tilt_tutorial_done:
		if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TILT:
			tilt_tutorial.visible = true
			self.disable_touches(true)
		else:
			tilt_tutorial.visible = false
	if !Manager.touch_tutorial_done:
		if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TOUCH:
			touch_tutorial.visible = true
			self.disable_touches(true)
		else:
			touch_tutorial.visible = false
	pass

func disable_touches(val):
	for i in touches:
		i.set_block_signals(val)
		
func set_space_ship_control():
	if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TOUCH:
		space_ship_control.get_node("touch").show()
	elif Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TILT:
		space_ship_control.get_node("touch").hide()
	elif Manager.space_ship_control==Manager.SPACE_SHIP_CONTROL.SLIDE:
		space_ship_control.get_node("touch").hide()
	pass
	
func set_variables_for_difficulty():
	if Manager.difficulty == Manager.DIFFICULTY.EASY:
		enemy_spawn_time = 1.4
		enemy_health = 100
		main_enemy_health = 2000
		main_electro_ball_time = 2
		main_electro_ball_speed = 1.5
		main_electro_ball_anim_speed_scale = 1
	if Manager.difficulty == Manager.DIFFICULTY.MEDIUM:
		enemy_spawn_time = 1.2
		enemy_health = 120
		main_enemy_health = 4000
		main_electro_ball_time = 1.5
		main_electro_ball_speed = 1.2
		main_electro_ball_anim_speed_scale = 1.2
	if Manager.difficulty == Manager.DIFFICULTY.HARD:
		enemy_spawn_time = .8
		enemy_health = 150
		main_enemy_health = 8000
		main_electro_ball_time = .8
		main_electro_ball_speed = .9
		main_electro_ball_anim_speed_scale = 2
	
			
func _on_texture_progress_bar_value_changed(value, texture_progress, type):
	var touch_btn = texture_progress.get_child(0)
	if value == 100:
		touch_btn.visible = true
		if type == "cross_bullets":
			touch_btn.pressed.connect(player.set_cross_bullets.bind(touch_btn))
		if  type == "asteroid":
			touch_btn.pressed.connect(player.asteroid.bind(touch_btn))
		if type == "shield":
			touch_btn.pressed.connect(self.set_protection.bind(touch_btn))
	if value == 0:
		if type == "shield":
			reset_protection()
			
func set_enemy_posn():
	var enemy_width = enemy.instantiate().get_node("Sprite2D").get_texture().get_width()*enemy.instantiate().get_node("Sprite2D").scale.x
	var division = Manager.win_size.x/5
	for posn in $enemy_pos.get_children():
		var posn_x = posn.global_position
		enemy_posn.push_back(posn_x)

func reset_protection():
	protection_enabled = false
	shield_t_progress.tint_progress.g = 1
	on_screen_controls.shield_positive = true
	var twn1 = create_tween()
	var twn2 = create_tween()
	stop_shield_particles()
	

func spawn_enemy():
	if Manager.game_start:
#		print(Manager.main_coming)
		if Manager.main_coming == false:
			var  e  = enemy.instantiate()
			var particle = enemy_emission_scene.instantiate()
			e.health = enemy_health
			e.global_position = enemy_posn.pick_random()
			
			enemy_node.add_child(e)

func set_variables():
	if get_tree().has_group("space_ships"):
		space_ships = get_tree().get_nodes_in_group("space_ships")[0]

	if get_tree().has_group("objects"):
		objects = get_tree().get_nodes_in_group("objects")[0]
		wall = objects.get_node("Area2D")
	if get_tree().has_group("enemy_spawner"):
		enemy_spawner = get_tree().get_nodes_in_group("enemy_spawner")[0]
	if get_tree().has_group("multiple_bull_t_progress"):
		multiple_bull_t_progress = get_tree().get_nodes_in_group("multiple_bull_t_progress")[0]
		
	if get_tree().has_group("power_ups_container"):
		power_ups_container = get_tree().get_nodes_in_group("power_ups_container")[0]	
	if get_tree().has_group("asteroid_t_progress"):
		asteroid_t_progress = get_tree().get_nodes_in_group("asteroid_t_progress")[0]

	if get_tree().has_group("shield_t_progress"):
		shield_t_progress = get_tree().get_nodes_in_group("shield_t_progress")[0]
	if get_tree().has_group("on_screen_controls"):
		on_screen_controls = get_tree().get_nodes_in_group("on_screen_controls")[0]
		Manager.status_label = on_screen_controls.get_node("status")
		Manager.score_update_label = on_screen_controls.score_label
		fps_meter = on_screen_controls.get_node("fps")
	if get_tree().has_group("pause_btn"):
		pause_btn = get_tree().get_nodes_in_group("pause_btn")[0]
		self.touches.push_back(pause_btn)
	if get_tree().has_group("restart_btn_of_go"):
		restart_btn1 = get_tree().get_nodes_in_group("restart_btn_of_go")[0]
	left_touch = space_ship_control.get_node("touch/Left")
	right_touch = space_ship_control.get_node("touch/Right")
	enemy_node= space_ships.get_node("Enemy")
	player_node = space_ships.get_node("Player")
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]
	
func connect_to_signals():
	
	multiple_bull_t_progress.value_changed.connect(_on_texture_progress_bar_value_changed.bind(multiple_bull_t_progress, "cross_bullets"))
	self.touches.push_back(multiple_bull_t_progress.get_child(0))
	
	
	
	shield_t_progress.value_changed.connect(_on_texture_progress_bar_value_changed.bind(shield_t_progress, "shield"))
	self.touches.push_back(shield_t_progress.get_child(0))
	
	
	pause_btn.pressed.connect(Manager.set_panel.bind(pause_menu, "show",self))
	pause_btn.pressed.connect(play_btn_sound)
	restart_btn1.pressed.connect(self.restart)
	restart_btn1.button_down.connect(play_btn_sound)
	

func connect_to_after_signals():
#	print(pause_menu.visible)
	if pause_menu.visible:
		if get_tree().has_group("close_btn_of_pm"):
			menu_close_btn1 = get_tree().get_nodes_in_group("close_btn_of_pm")[0]
		if get_tree().has_group("resume_btn_of_pm"):
			resume_btn = get_tree().get_nodes_in_group("resume_btn_of_pm")[0]
		if get_tree().has_group("restart_btn_of_pm"):
			restart_btn2 = get_tree().get_nodes_in_group("restart_btn_of_pm")[0]
		if get_tree().has_group("main_menu_btn_of_pm"):
			menu_btn = get_tree().get_nodes_in_group("main_menu_btn_of_pm")[0]
		if get_tree().has_group("settings_btn_of_pm"):
			settings_btn = get_tree().get_nodes_in_group("settings_btn_of_pm")[0]
#		print(resume_btn.name)
		menu_close_btn1.pressed.connect(Manager.set_panel.bind(pause_menu, "hide", self))
		menu_close_btn1.button_down.connect(play_btn_sound)
		
		restart_btn2.pressed.connect(self.restart)
		restart_btn2.button_down.connect(play_btn_sound)
		
		resume_btn.pressed.connect(Manager.set_panel.bind(pause_menu, "hide", self))
		resume_btn.button_down.connect(play_btn_sound)
		
		menu_btn.pressed.connect(to_main_menu)
		menu_btn.button_down.connect(play_btn_sound)
			
		settings_btn.pressed.connect(Manager.set_panel.bind(in_game_settings, "show", self, pause_menu))
		settings_btn.button_down.connect(play_btn_sound)
			
		self.disable_touches(true)
		
	if in_game_settings.visible:
		var close_btn
		var music
		var FPS
		var sound
		
		if get_tree().has_group("close_btn_of_igs"):
			close_btn = get_tree().get_nodes_in_group("close_btn_of_igs")[0]
		if get_tree().has_group("music_check_box_of_igs"):
			music = get_tree().get_nodes_in_group("music_check_box_of_igs")[0]
		if get_tree().has_group("sound_check_box_of_igs"):
			sound = get_tree().get_nodes_in_group("sound_check_box_of_igs")[0]
		if get_tree().has_group("fps_check_box_of_igs"):
			FPS = get_tree().get_nodes_in_group("fps_check_box_of_igs")[0]

		music.toggled.connect(Manager.set_sound.bind("music"))
		music.toggled.connect(play_btn_sound)
		sound.toggled.connect(Manager.set_sound.bind("sound"))
		sound.toggled.connect(play_btn_sound)
		FPS.toggled.connect(set_fps_meter)
		FPS.toggled.connect(play_btn_sound)
		close_btn.pressed.connect(Manager.set_panel.bind(in_game_settings, "hide", self))
		close_btn.button_down.connect(play_btn_sound)

func play_btn_sound(arg = null):
	Manager.sound_man.play_button_sound()
	
func set_fps_meter(btn_pressed):
	fps_meter.visible = btn_pressed
	Manager.enable_fps = btn_pressed
	

func to_main_menu():
	var error = get_tree().change_scene_to_file(main_menu)

func set_protection(touch_btn):
	Manager.status_update("shield activated!")
	protection_enabled = true
	touch_btn.visible = false
	shield_t_progress.tint_progress.g = .7

	start_shield_particles()

	on_screen_controls.shield_positive = false

func start_shield_particles():
	var twn = get_tree().create_tween()
	twn.tween_property(shield_particle, "modulate", Color(1,1,1, 1), 1)
	twn.play()
	
func stop_shield_particles():
	var twn = get_tree().create_tween()
	twn.tween_property(shield_particle, "modulate",Color(1,1,1,0), 1.5)
	twn.play()
	
func restart():
	get_tree().reload_current_scene()
	Manager.reset_variables()

	
func add_player():
	player_node.add_child(player)



func debug(txt):
	var label = Label.new()
	label.text = txt
	label.position = Vector2(300,200)
	label.z_index = 50
	objects.add_child(label)
	
func detect_collision():
	var overlapping_areas = wall.get_overlapping_areas()
	if protection_enabled == false:
		for i in overlapping_areas:
			if i.is_in_group("enemy"):
				#Manager.set_panel(game_over, "show", self)
				i.self_destroy()
				player.decrease_health(i.damage)
				pause_btn.set_block_signals(true)
	if protection_enabled:
		for i in overlapping_areas:
			if i.is_in_group("enemy"):
				i.queue_free()
	

func _on_enemy_spawner_timeout():
	spawn_enemy()
	enemy_spawner.wait_time = enemy_spawn_time + randf_range(0, .9)
	pass # Replace with function body.

func main_enemy_spawner():
	self.on_main_coming()
	Manager.status_update("Alert!")
#		await get_tree().create_timer(2).timeout
	for small_enemy in enemy_node.get_children():
		if small_enemy.is_in_group("enemy"):
			var twn = create_tween()
			twn.tween_property(small_enemy, "visible", false, .1)
			twn.tween_callback(small_enemy.queue_free)
			twn.play()
#			twn.finished.connect(small_enemy_free.bind(small_enemy)
	Manager.connect("main_reached_signal", on_main_reached)
	var e = main_enemy.instantiate()
	set_main_enemy_instance(e)
	e.health = main_enemy_health
	e.electro_ball_time = main_electro_ball_time
	e.electro_ball_speed = main_electro_ball_speed
	e.position.x = Manager.win_size.x/2
	e.electro_ball_anim_speed_scale = main_electro_ball_anim_speed_scale
	e.position.y = -e.get_node("Sprite2D").get_texture().get_height()/2*e.get_node("Sprite2D").scale.y
	enemy_node.add_child(e)

	pass

func set_main_enemy_instance(value):
	main_enemy_instance = value

func get_main_enemy_instance():
	return main_enemy_instance
	
func spawn_collectable(pos):
	var rand = randi()%100
	var collectable = collectables_scene.instantiate()
	collectable.global_position = pos
	if !rand<80:
		collectable.reference_color = Color.YELLOW
		collectable.COLL_TYPE = Manager.COLL_TYPES.COIN
		collectables_container.add_child(collectable)
		collectable.set_texture(coin_texture)
		
	if !rand<90:
		collectable.reference_color = Color.GREEN_YELLOW
		collectable.COLL_TYPE = Manager.COLL_TYPES.MULTIPLIER
		collectables_container.add_child(collectable)
		collectable.set_texture(multiplier_texture)
	if rand>20 && rand<25:
		collectable.reference_color = Color.CORNFLOWER_BLUE
		collectable.COLL_TYPE = Manager.COLL_TYPES.BULLETS
		collectables_container.add_child(collectable)
		collectable.set_texture(bullets_texture)
	pass



