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
	center_container = self.get_parent()
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]

	margin_container = get_node("MarginContainer")


func set_variables():
	if get_tree().has_group("label_of_ogs"):
		label  = get_tree().get_nodes_in_group("label_of_ogs")[0]
	if get_tree().has_group("close_btn_of_ogs"):
		btn1 = get_tree().get_nodes_in_group("close_btn_of_ogs")[0]
	if get_tree().has_group("controls_btn_of_ogs"):
		btn2 = get_tree().get_nodes_in_group("controls_btn_of_ogs")[0]
	if get_tree().has_group("audio_btn_of_ogs"):
		btn3 = get_tree().get_nodes_in_group("audio_btn_of_ogs")[0]

	pass


