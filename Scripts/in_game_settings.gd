extends PanelContainer

var center_container
var margin_container 
var sound_man
var label
var btn1 
var btn2 
var btn3 
var btn4 

func _ready():
	set_variables()
	set_tick()
	center_container = self.get_parent()



func set_variables():
	if get_tree().has_group("label_of_igs"):
		label  = get_tree().get_nodes_in_group("label_of_igs")[0]
	if get_tree().has_group("close_btn_of_igs"):
		btn1 = get_tree().get_nodes_in_group("close_btn_of_igs")[0]
	if get_tree().has_group("music_check_box_of_igs"):
		btn2 = get_tree().get_nodes_in_group("music_check_box_of_igs")[0]
	if get_tree().has_group("sound_check_box_of_igs"):
		btn3 = get_tree().get_nodes_in_group("sound_check_box_of_igs")[0]
	if get_tree().has_group("fps_check_box_of_igs"):
		btn4 = get_tree().get_nodes_in_group("fps_check_box_of_igs")[0]

func set_tick():
	$MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/Music.button_pressed = Manager.enable_music
	$MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/Sound.button_pressed = Manager.enable_sound
	$MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/FPS.button_pressed = Manager.enable_fps
	
