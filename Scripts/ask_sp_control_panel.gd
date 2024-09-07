extends PanelContainer

var center_container
var margin_container 
var sound_man
@onready var label
@onready var btn1 
@onready var btn2 
@onready var btn3 

func _ready():
	set_variables()
	set_tick()
	pass


func set_variables():
	if get_tree().has_group("label_of_ask_sp_control_panel"):
		label = get_tree().get_nodes_in_group("label_of_ask_sp_control_panel")[0]

	if get_tree().has_group("close_btn_of_ask_sp_control_panel"):
		btn1  = get_tree().get_nodes_in_group("close_btn_of_ask_sp_control_panel")[0]
	if get_tree().has_group("touch_btn_of_ask_sp_control_panel"):
		btn2 = get_tree().get_nodes_in_group("touch_btn_of_ask_sp_control_panel")[0]
	if get_tree().has_group("tilt_btn_of_ask_sp_control_panel"):
		btn3 = get_tree().get_nodes_in_group("tilt_btn_of_ask_sp_control_panel")[0]
	pass

func set_tick():
	var touch_tick = $MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/touch.get_node("TextureRect")
	var tilt_tick = $MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/tilt.get_node("TextureRect2")
	var slide_tick = $MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/items_list/slide.get_node("TextureRect2")
	if Manager.space_ship_control == Manager.SPACE_SHIP_CONTROL.TOUCH:
		touch_tick.show()
		tilt_tick.hide()
		slide_tick.hide()
	elif Manager.space_ship_control==Manager.SPACE_SHIP_CONTROL.TILT:
		tilt_tick.show()
		touch_tick.hide()
		slide_tick.hide()
	elif Manager.space_ship_control==Manager.SPACE_SHIP_CONTROL.SLIDE:
		slide_tick.show()
		touch_tick.hide()
		tilt_tick.hide()


