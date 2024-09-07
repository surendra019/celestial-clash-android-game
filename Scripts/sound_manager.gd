extends Node2D

@onready var status_message = get_node("status_message")
@onready var bullet_fire = get_node("bullet_fire")
@onready var button  = get_node("button")
@onready var bg_music_menu = get_node("bg_music_menu")
@onready var dmg_sound = get_node("dmg_sound")
@onready var coin_collected = get_node("coin_collected")

func _ready():
	pass

func play_dmg_sound():
	if Manager.enable_sound:
		dmg_sound.play(.3)
		
func play_bg_music_menu():
	if Manager.enable_music:
		bg_music_menu.play()
		
func stop_bg_music_menu():
	bg_music_menu.stop()
func play_status_message():
	if Manager.enable_sound:
		status_message.play()


func play_bullet_fire():
	if Manager.enable_sound:
		bullet_fire.play()
	pass

func play_button_sound(arg=  null):
	if Manager.enable_sound:
		button.play()
	pass

func play_coin_collected():
	if Manager.enable_sound:
		coin_collected.play()
	pass
