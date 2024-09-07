extends Control

@onready var image = get_node("TextureRect")
@onready var progress = get_node("ProgressBar")
@onready var label = get_node("Label")

@onready var game = "res://Scenes/in_game.tscn"

func _ready():
	Manager.sound_man.stop_bg_music_menu()
	Manager.enable_music = false
	
	self.size = Manager.win_size

#	Manager.set_font_dimension(label, 20)
	progress.value = 0
	progress.value_changed.connect(start_game)

func _process(delta):
	progress.value+= Engine.get_process_frames()*delta

func start_game(value):
	if value == progress.max_value:
		get_tree().change_scene_to_file(game)
