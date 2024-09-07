extends Node

signal main_reached_signal

var win_size = DisplayServer.window_get_size()
var game_start = false
var wall
var score = 0
var coin = 0
var total_coins:int

var multiplier = 1

var sound_man = preload("res://Scenes/sound_manager.tscn").instantiate()
var status_label
var score_update_label

var score_ups1

#main_enemy
var main_coming = false
var main_reached = false
var main_spawned = false

var set_further_score_enabled = false
var main_enemy_specific_scores = [150]
var rand_score_for_main_enemy_spawn = randi_range(main_enemy_specific_scores[-1]+50, main_enemy_specific_scores[-1]+200)
var in_game
var enable_music
var enable_sound
var enable_fps
var FILE_NAME = "res://Saves/settings.tres"
var game_data = game_saver.new()

enum DIFFICULTY {EASY, MEDIUM, HARD}
var difficulty

enum SPACE_SHIP_CONTROL {TOUCH,TILT, SLIDE}
var space_ship_control = SPACE_SHIP_CONTROL.SLIDE


var v_sep_bw_head_and_contents_in_panel = 15

var anim_running = false

var head_font_size = 35
var content_font_size = 30

var p_margin_left =win_size.x/20
var p_margin_right = win_size.x/20
var p_margin_top = 0
var p_margin_bottom = win_size.y/40

var touches = []
#tutorial
var tilt_tutorial_done
var touch_tutorial_done


enum COLL_TYPES {COIN, MULTIPLIER, BULLETS}



func load_data():
	game_data = ResourceLoader.load(FILE_NAME)
	total_coins = game_data.coins
	enable_music = game_data.AUDIO["music"]
	enable_sound = game_data.AUDIO["sound"]
	enable_fps = game_data.fps_enable
	space_ship_control =game_data.space_ship_control
	tilt_tutorial_done = game_data.tilt_tutorial_done
	touch_tutorial_done = game_data.touch_tutorial_done
	pass

func save_data():
	game_data.coins = total_coins
	game_data.AUDIO["music"] = enable_music
	game_data.AUDIO["sound"] = enable_sound
	game_data.fps_enable = enable_fps
	game_data.space_ship_control = space_ship_control
	game_data.tilt_tutorial_done = tilt_tutorial_done
	game_data.touch_tutorial_done = touch_tutorial_done
	ResourceSaver.save(game_data, FILE_NAME)
	
func set_main_enemy_var():
		main_spawned = false
		main_coming = false
		main_reached = false
		
func on_main_reached():
	main_reached = true
	emit_signal("main_reached_signal")

func _ready():
	sound_man.add_to_group("sound_manager")
	self.add_child(sound_man)
#	DisplayServer.window_set_size(DisplayServer.screen_get_size())
	win_size = DisplayServer.window_get_size()
	if ResourceLoader.exists(FILE_NAME):
		load_data()
	if !ResourceLoader.exists(FILE_NAME):
		reset_save_file()
	

func reset_save_file():
		total_coins = 0
		enable_fps = true
		enable_music = true
		enable_sound = true
		space_ship_control = SPACE_SHIP_CONTROL.TOUCH
		tilt_tutorial_done = false
		touch_tutorial_done = false
		save_data()
		load_data()
		
		
func status_update(txt):
	if game_start:
		if status_label.text.length()!=0:
			status_label.text = ""
		status_label.visible = true
		sound_man.play_status_message()
		if !anim_running:
			for letter in txt.length():
				status_label.text += txt[letter]
				await  get_tree().create_timer(.01).timeout
				anim_running = true
			anim_running = false
		await  get_tree().create_timer(2).timeout
		status_label.visible = false
		txt = ""

	
func update_score(val, label):
	score += val*multiplier
	label.text = str(score)
	
	var rand_in_score1 = randi_range(200, 300)
	if score>rand_in_score1 and not score_ups1:
		status_update("keep it up chief!")
		score_ups1 = true
#	print(rand_score_for_main_enemy_spawn)
#	print(score)
	if set_further_score_enabled:
		set_further_score()
		set_further_score_enabled = false
	if score> rand_score_for_main_enemy_spawn and not main_spawned and set_further_score_enabled:
		#set_main_enemy_var()
		#print(rand_score_for_main_enemy_spawn)
#		print(score)
		#in_game.main_enemy_spawner()
		#main_spawned = true
		pass
			
	if score> rand_score_for_main_enemy_spawn and not main_spawned and ! set_further_score_enabled:
		#set_main_enemy_var()
		#print(rand_score_for_main_enemy_spawn)
		#in_game.main_enemy_spawner()
		#main_spawned = true
		pass

func update_coin(val, label):
	coin += val
	total_coins +=val
	label.text = str(coin)

func _physics_process(delta):

	pass

func set_further_score():
#	await  get_tree().create_timer(2).timeout
	main_enemy_specific_scores.push_back(score)
	main_enemy_specific_scores.pop_front()
	rand_score_for_main_enemy_spawn = randi_range(main_enemy_specific_scores[-1]+50, main_enemy_specific_scores[-1]+200)
#	print(rand_score_for_main_enemy_spawn)
	
func _process(delta):
	win_size = DisplayServer.window_get_size()

func set_panel_bef_game_start(obj, work, main= null, prev_panel = null):
		if work == "show":
			obj.visible = true
		if prev_panel!=null:
			prev_panel.visible = false
		if main!=null:
			if main.has_method("disable_touches"):
				main.disable_touches(true)
			if main.has_method("connect_to_after_signals"):
				main.connect_to_after_signals()
		if work == "hide":
			obj.visible = false

func set_panel(obj, work,main = null, prev_panel = null):
	if work == "show":
		if prev_panel!=null:
			prev_panel.visible = false
		obj.visible = true
		if main!=null:
			if main.has_method("disable_touches"):
				main.disable_touches(true)
			if main.has_method("connect_to_after_signals"):
				main.connect_to_after_signals()
		game_start = false
	if work == "hide":
		obj.visible = false
		if main!=null:
			if main.has_method("disable_touches"):
				main.disable_touches(false)
		game_start = true
		if main!=null:
			if main.has_method("get_main_enemy_instance"):
				if main.get_main_enemy_instance()!=null:
					main.get_main_enemy_instance().reset_timer()
	
		
		

func set_sound(btn_pressed, work):
	if work == "music":
		enable_music = btn_pressed
		if !game_start:
			if !btn_pressed:
				sound_man.stop_bg_music_menu()
			elif btn_pressed:
				sound_man.play_bg_music_menu()
		game_data.AUDIO["music"] = btn_pressed
	if work == "sound":
		enable_sound = btn_pressed
		game_data.AUDIO["sound"] = btn_pressed
		
func set_sp_conrol(mode):
	space_ship_control = mode

func set_pos(obj):
	var natural_win_size = Vector2(432, 904)
	obj.position.x = (obj.position.x/natural_win_size.x)*win_size.x
	obj.position.y = (obj.position.y/natural_win_size.y)*win_size.y
	pass

func quit():
	save_data()
	get_tree().quit()

func _notification(what):
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()

func set_select_design(btn_arr):

	var selected_style = preload("res://Styles/buttons/selected_btn.tres")
	var normal_style = preload("res://Styles/buttons/button.tres")

	for btn in btn_arr:
		if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TOUCH and btn.name == "touch":
			btn.get_child(0).show()
		elif Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TILT and btn.name == "tilt":
			btn.get_child(0).show()
		elif Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.SLIDE and btn.name == "slide":
			btn.get_child(0).show()
		else:
			btn.get_child(0).hide()

func reset_variables():
	score = 0
	main_coming = false
	main_spawned = false
	main_reached = false
	multiplier = 1
	main_enemy_specific_scores = [150]
	rand_score_for_main_enemy_spawn = randi_range(main_enemy_specific_scores[-1]+50, main_enemy_specific_scores[-1]+200)

func set_single_val_acc_to_window(obj, prop, alignment):
	if alignment == "vertical":
		obj.set(prop, ((obj.get(prop)/904)*win_size.y))
	if alignment == "horizontal":
		obj.set(prop, (obj.get(prop)/432)*win_size.x)
	pass

func set_panel_margin(margin_c, ver= (win_size.y*(float(10)/904)), hor= (win_size.x*(float(5)/432))):

	margin_c.set("theme_override_constants/margin_left", hor)
	margin_c.set("theme_override_constants/margin_top", ver)
	margin_c.set("theme_override_constants/margin_right", hor)
	margin_c.set("theme_override_constants/margin_bottom", ver)

	pass
