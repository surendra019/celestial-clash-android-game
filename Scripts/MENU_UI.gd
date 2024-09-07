extends CanvasLayer

@onready var control_main = get_node("Control")
@onready var margin_container  = get_node("Control/MarginContainer")
@onready var title_label = get_node("Control/MarginContainer/VBoxContainer/Label")
@onready var button_margin_c = get_node("Control/MarginContainer/VBoxContainer/button_margin_c")
@onready var play_btn = get_node("Control/MarginContainer/VBoxContainer/button_margin_c/VBoxContainer/PlayBtn")
@onready var quit_btn = get_node("Control/MarginContainer/VBoxContainer/button_margin_c/VBoxContainer/QuitBtn")
@onready var settings_btn = get_node("Control/MarginContainer/VBoxContainer/button_margin_c/VBoxContainer/SettingsBtn")

func _ready():
	
	set_label()

	


func set_label():
	var font = preload("res://Fonts/Inconsolata-Bold.ttf")
#	Manager.set_font_dimension(title_label, 60, font)


