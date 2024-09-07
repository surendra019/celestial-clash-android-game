extends PanelContainer

@onready var label
@onready var btn2 
@onready var btn3 
@onready var sound_man 
var margin_container 
var in_game
var center_container 

func _ready():
	
	set_variables()
	center_container = self.get_parent()
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]


func set_variables():
	if get_tree().has_group("label_of_go"):
		label  = get_tree().get_nodes_in_group("label_of_go")[0]
	if get_tree().has_group("revive_btn_of_go"):
		btn2 = get_tree().get_nodes_in_group("revive_btn_of_go")[0]
	if get_tree().has_group("restart_btn_of_go"):
		btn3 = get_tree().get_nodes_in_group("restart_btn_of_go")[0]
	if get_tree().has_group("in_game"):
		in_game = get_tree().get_nodes_in_group("in_game")[0]

	pass



