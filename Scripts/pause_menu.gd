extends PanelContainer

@onready var label
@onready var btn1
@onready var btn2
@onready var btn3
@onready var btn4
@onready var btn5
@onready var sound_man 

var margin_container 

func _ready():
	set_variables()
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]


	pass

func set_variables():
	if get_tree().has_group("label_of_pm"):
		label = get_tree().get_nodes_in_group("label_of_pm")[0]
	if get_tree().has_group("close_btn_of_pm"):
		btn1= get_tree().get_nodes_in_group("close_btn_of_pm")[0]
	if get_tree().has_group("resume_btn_of_pm"):
		btn2 = get_tree().get_nodes_in_group("resume_btn_of_pm")[0]
	if get_tree().has_group("restart_btn_of_pm"):
		btn3 = get_tree().get_nodes_in_group("restart_btn_of_pm")[0]
	if get_tree().has_group("main_menu_btn_of_pm"):
		btn4 = get_tree().get_nodes_in_group("main_menu_btn_of_pm")[0]
	if get_tree().has_group("settings_btn_of_pm"):
		btn5 = get_tree().get_nodes_in_group("settings_btn_of_pm")[0]


