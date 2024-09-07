extends Control

@onready var texture_progress = get_node("VBoxContainer/multiple_bullets")
@onready var score_label
@onready var shield  = get_node("VBoxContainer/shield")
@onready var status_label = get_node("status")
@onready var fps_meter = get_node("fps")
@onready var progress_bar = get_node("ProgressBar")
@onready var powerup_progress = $multiplier_power_up
@onready var bullet_speed_power_up = $bullet_speed_power_up
@onready var hits_label = $hits_label
var coin_label

var shield_positive = true
var power_up_enabled = false
var bullet_speed_power_up_enabled = false

func _physics_process(delta):
	if Manager.game_start:
		if shield_positive:
			shield.value+=(20*delta)/3
		if shield_positive == false:
			shield.value-=8*delta
		if power_up_enabled:
			powerup_progress.value -=8*delta
		if bullet_speed_power_up_enabled:
			bullet_speed_power_up.value -=8*delta
			
func _ready():
	hits_label.modulate = Color(1,1,1,1)
	set_power_up_progress()
	
	hits_label.scale = Vector2(0,0)
	if get_tree().has_group("score_label"):
		score_label = get_tree().get_nodes_in_group("score_label")[0]
		score_label.text = "0"
	if get_tree().has_group("coin_label"):
		coin_label = get_tree().get_nodes_in_group("coin_label")[0]
		coin_label.text = "0"
	

	fps_meter.visible = Manager.enable_fps
	pass
func set_power_up_progress():
	powerup_progress.hide()
	powerup_progress.value = 100
	bullet_speed_power_up.hide()
	bullet_speed_power_up.value = 100
	pass

func _on_powerup_progress_value_changed(value):
	if value==0:
		Manager.multiplier = 1
		powerup_progress.hide()
	pass # Replace with function body.


func show_hits_label(val):
	hits_label.text = str(val)+"x"
	hits_label.modulate = Color(1,1,1,1)
	hits_label.show()
	var twn = create_tween()
	twn.tween_property(hits_label, "scale", Vector2(1, 1), .2).set_ease(Tween.EASE_IN)
	twn.play()
	twn.finished.connect(_on_hits_label_showed)
	pass

func _on_hits_label_showed():
	await get_tree().create_timer(1).timeout
	var twn = create_tween()
	twn.tween_property(hits_label, "modulate", Color(1,1,1,0), .5).set_ease(Tween.EASE_IN)
	twn.play()
	twn.finished.connect(_on_hits_label_faded_out)
	
func _on_hits_label_faded_out():
	hits_label.hide()


func _on_bullet_speed_power_up_value_changed(value):
	if value==0:
		Manager.in_game.player.bullet_time = 0.2
		bullet_speed_power_up.hide()
	pass # Replace with function body.
