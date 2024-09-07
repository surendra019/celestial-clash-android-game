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


	pass


func set_variables():
	if get_tree().has_group("label_of_mode_menu"):
		label  = get_tree().get_nodes_in_group("label_of_mode_menu")[0]
	if get_tree().has_group("close_btn_of_mode_menu"):
		btn1 = get_tree().get_nodes_in_group("close_btn_of_mode_menu")[0]
	if get_tree().has_group("easy_btn_of_mode_menu"):
		btn2 = get_tree().get_nodes_in_group("easy_btn_of_mode_menu")[0]
	if get_tree().has_group("medium_btn_of_mode_menu"):
		btn3 = get_tree().get_nodes_in_group("medium_btn_of_mode_menu")[0]
	if get_tree().has_group("hard_btn_of_mode_menu"):
		btn4 = get_tree().get_nodes_in_group("hard_btn_of_mode_menu")[0]
