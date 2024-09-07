extends Control

@onready var c1 = get_node("ColorRect")
@onready var title = get_node("ColorRect/MarginContainer/VBoxContainer/Label")
@onready var logo = get_node("ColorRect/MarginContainer/VBoxContainer/TextureRect")
@onready var vbox = get_node("ColorRect/MarginContainer//VBoxContainer")
@onready var c2 = get_node("ColorRect2")
var menu = "res://Scenes/menu.tscn"
@onready var margin_container = get_node("ColorRect/MarginContainer")

var pl = "res://Scenes/player.tscn"
func _ready():
	var font = preload("res://Fonts/Inconsolata-Bold.ttf")
	
	start_anim()
	

func start_anim():
	var twn = create_tween()
	twn.tween_property(c2, "self_modulate", Color(0,0,0,0), 3)
	twn.play()
	await  twn.finished
	await get_tree().create_timer(3).timeout
	start_game()
	
func start_game():
	get_tree().change_scene_to_file(menu)
	
