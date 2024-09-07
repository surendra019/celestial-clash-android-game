extends PanelContainer

@onready var label
@onready var btn1
@onready var btn2 
@onready var btn3 
@onready var sound_man 
var margin_container
var center_container 

func _ready():
	set_variables()
	btn2.button_pressed = Manager.enable_music
	btn3.button_pressed = Manager.enable_sound
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]


func set_variables():
	if get_tree().has_group("label_of_audio_panel"):
		label=  get_tree().get_nodes_in_group("label_of_audio_panel")[0]
	if get_tree().has_group("close_btn_of_audio_panel"):
		btn1 = get_tree().get_nodes_in_group("close_btn_of_audio_panel")[0]
	if get_tree().has_group("music_check_box_of_audio_panel"):
		btn2 = get_tree().get_nodes_in_group("music_check_box_of_audio_panel")[0]
	if get_tree().has_group("sound_check_box_of_audio_panel"):
		btn3 = get_tree().get_nodes_in_group("sound_check_box_of_audio_panel")[0]



