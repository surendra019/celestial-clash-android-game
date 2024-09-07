extends Control

@onready var menu_bg = get_node("bg")
@onready var in_game = ("res://Scenes/in_game.tscn")
@onready var bg_anim_node = get_node("bg_anim")
@onready var sound_man
var game_loading =("res://Scenes/loading_bg.tscn")



#popups
@onready var mode_menu = get_node("popups/mode_menu")
@onready var settings_menu = get_node("popups/out_game_settings")
@onready var audio_panel = get_node("popups/audio_panel")
@onready var ask_sp_control_panel = get_node("popups/ask_sp_control_panel")

@onready var earth = get_node("bg/Sprite2D")
@onready var total_coins_label = $UI/gui/Control/PanelContainer/total_coins

func _ready():
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]

	Manager.sound_man.play_bg_music_menu()
	total_coins_label.text = str(Manager.total_coins)
	

func _on_play_btn_pressed():
	Manager.set_panel_bef_game_start(mode_menu, "show", self) 
#	get_tree().change_scene_to_file("res://Scenes/loading_bg.tscn")
	Manager.reset_variables()
	pass # Replace with function body.

func enable_easy_mode():
	Manager.difficulty = Manager.DIFFICULTY.EASY
	get_tree().change_scene_to_file(game_loading) 


func enable_medium_mode():
	Manager.difficulty = Manager.DIFFICULTY.MEDIUM
	get_tree().change_scene_to_file(game_loading) 
	pass
	
func enable_hard_mode():
	Manager.difficulty = Manager.DIFFICULTY.HARD
	get_tree().change_scene_to_file(game_loading) 
	pass

func connect_to_after_signals():
	if mode_menu.visible:
		if get_tree().has_group("close_btn_of_mode_menu"):
			var close_btn = get_tree().get_nodes_in_group("close_btn_of_mode_menu")[0]
			close_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(mode_menu, "hide", self))
			close_btn.button_down.connect(sound_man.play_button_sound)
		if get_tree().has_group("easy_btn_of_mode_menu"):
			var easy_btn = get_tree().get_nodes_in_group("easy_btn_of_mode_menu")[0]	
			easy_btn.button_down.connect(sound_man.play_button_sound)
			easy_btn.pressed.connect(enable_easy_mode)

		if get_tree().has_group("medium_btn_of_mode_menu"):
			var medium_btn = get_tree().get_nodes_in_group("medium_btn_of_mode_menu")[0]
			medium_btn.button_down.connect(sound_man.play_button_sound)
			medium_btn.pressed.connect(enable_medium_mode)
		if get_tree().has_group("hard_btn_of_mode_menu"):
			var hard_btn = get_tree().get_nodes_in_group("hard_btn_of_mode_menu")[0]
			hard_btn.button_down.connect(sound_man.play_button_sound)
			hard_btn.pressed.connect(enable_hard_mode)


	if settings_menu.visible:
		if get_tree().has_group("close_btn_of_ogs"):
			var close_btn = get_tree().get_nodes_in_group("close_btn_of_ogs")[0]
			close_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(settings_menu, "hide", self))
			close_btn.button_down.connect(sound_man.play_button_sound)
		if get_tree().has_group("controls_btn_of_ogs"):
			var controls_btn = get_tree().get_nodes_in_group("controls_btn_of_ogs")[0]	
			controls_btn.button_down.connect(sound_man.play_button_sound)
			controls_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(ask_sp_control_panel, "show", self, settings_menu))
		
		if get_tree().has_group("audio_btn_of_ogs"):
			var audio_btn = get_tree().get_nodes_in_group("audio_btn_of_ogs")[0]
			audio_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(audio_panel, "show", self, settings_menu))
			audio_btn.button_down.connect(sound_man.play_button_sound)


	

	if audio_panel.visible:
		if get_tree().has_group("close_btn_of_audio_panel"):
			var close_btn = get_tree().get_nodes_in_group("close_btn_of_audio_panel")[0]
			close_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(audio_panel, "hide", self))
			close_btn.button_down.connect(sound_man.play_button_sound)
		if get_tree().has_group("music_check_box_of_audio_panel"):
			var music_check_box = get_tree().get_nodes_in_group("music_check_box_of_audio_panel")[0]
			music_check_box.toggled.connect(sound_man.play_button_sound)
			music_check_box.toggled.connect(Manager.set_sound.bind("music"))
		if get_tree().has_group("sound_check_box_of_audio_panel"):
			var sound_check_box = get_tree().get_nodes_in_group("sound_check_box_of_audio_panel")[0]
			sound_check_box.toggled.connect(sound_man.play_button_sound)
			sound_check_box.toggled.connect(Manager.set_sound.bind("sound"))

	
	if ask_sp_control_panel.visible:
		var tilt_btn
		var touch_btn
		var slide_btn
		if get_tree().has_group("touch_btn_of_ask_sp_control_panel"):
			touch_btn = get_tree().get_nodes_in_group("touch_btn_of_ask_sp_control_panel")[0]
		if get_tree().has_group("tilt_btn_of_ask_sp_control_panel"):
			tilt_btn = get_tree().get_nodes_in_group("tilt_btn_of_ask_sp_control_panel")[0]
		if get_tree().has_group("slide_btn_of_ask_sp_control_panel"):
			slide_btn = get_tree().get_nodes_in_group("slide_btn_of_ask_sp_control_panel")[0]
		if get_tree().has_group("close_btn_of_ask_sp_control_panel"):
			var close_btn = get_tree().get_nodes_in_group("close_btn_of_ask_sp_control_panel")[0]
			close_btn.button_down.connect(sound_man.play_button_sound)
			close_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(ask_sp_control_panel, "hide", self))
		
		var btn_arr = [slide_btn, touch_btn, tilt_btn]
		touch_btn.pressed.connect(Manager.set_sp_conrol.bind(Manager.SPACE_SHIP_CONTROL.TOUCH))
		touch_btn.button_down.connect(sound_man.play_button_sound)
#		touch_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(ask_sp_control_panel, "hide", self))
		touch_btn.pressed.connect(Manager.set_select_design.bind(btn_arr))
		
		tilt_btn.pressed.connect(Manager.set_sp_conrol.bind(Manager.SPACE_SHIP_CONTROL.TILT))
		tilt_btn.button_down.connect(sound_man.play_button_sound)
#		tilt_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(ask_sp_control_panel, "hide", self))
		tilt_btn.pressed.connect(Manager.set_select_design.bind(btn_arr))
		
		slide_btn.pressed.connect(Manager.set_sp_conrol.bind(Manager.SPACE_SHIP_CONTROL.SLIDE))
		slide_btn.button_down.connect(sound_man.play_button_sound)
#		slide_btn.pressed.connect(Manager.set_panel_bef_game_start.bind(ask_sp_control_panel, "hide", self))
		slide_btn.pressed.connect(Manager.set_select_design.bind(btn_arr))
			

func _on_quit_btn_pressed():
	Manager.quit()
	pass # Replace with function body.


func _on_play_btn_button_down():
	sound_man.play_button_sound()
	pass # Replace with function body.


func _on_settings_btn_button_down():
	sound_man.play_button_sound()
	pass # Replace with function body.


func _on_quit_btn_button_down():
	sound_man.play_button_sound()
	pass # Replace with function body.


func _on_settings_btn_pressed():
	Manager.set_panel_bef_game_start(settings_menu, "show", self)
	pass
