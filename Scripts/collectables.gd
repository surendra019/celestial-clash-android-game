
extends Node2D

@onready var texture_node = $TextureRect
var reference_color:Color = Color.BLACK
var float_mag = 10
@onready var particles = $GPUParticles2D
var COLL_TYPE
@onready var sound_man

var blasted = false
var color_ramp = preload("res://Other resources/color_ramp_for_particles.tres")



func set_texture(texture):
	texture_node.texture = texture

func _physics_process(delta):
	var rand_mag = randi()%float_mag
	var rand_pos_x = randi_range(self.global_position.x-rand_mag, self.global_position.x+rand_mag)
	var rand_pos_y = randi_range(self.global_position.y-rand_mag, self.global_position.y+rand_mag)
	
	var lerp_x = lerp(self.global_position.x, float(rand_pos_x), 0.1)
	var lerp_y = lerp(self.global_position.y, float(rand_pos_y), 0.1)
	
	self.global_position = Vector2(lerp_x, lerp_y)

func blast():
	$Sprite2D.hide()
	$TextureRect.hide()
	var on_screen_controls = get_tree().get_nodes_in_group("on_screen_controls")[0]
	if COLL_TYPE == Manager.COLL_TYPES.COIN:
		sound_man.play_coin_collected()
		var rand_coin = randi()%100
		Manager.update_coin(rand_coin, get_tree().get_nodes_in_group("coin_label")[0])
	elif COLL_TYPE ==Manager.COLL_TYPES.MULTIPLIER:
		
		Manager.multiplier = Manager.multiplier*2
		
		on_screen_controls.powerup_progress.show()
		on_screen_controls.power_up_enabled = true
		on_screen_controls.powerup_progress.value = 100
		on_screen_controls.show_hits_label(Manager.multiplier)
		
	elif COLL_TYPE == Manager.COLL_TYPES.BULLETS:
		Manager.in_game.player.bullet_time = 0.07
		on_screen_controls.bullet_speed_power_up.show()
		on_screen_controls.bullet_speed_power_up_enabled = true
		on_screen_controls.bullet_speed_power_up.value = 100
		
		
	particles.process_material.color = reference_color
	color_ramp.gradient.set_color(0, reference_color)
	particles.process_material.color_ramp = color_ramp
	particles.emitting = true
	particles.get_node('Timer').wait_time = 2
	particles.get_node('Timer').start()
	pass


func _ready():
	randomize()
	if get_tree().has_group("sound_manager"):
		sound_man = get_tree().get_nodes_in_group("sound_manager")[0]
	await  get_tree().create_timer(10).timeout
	self.queue_free()

func _on_timer_timeout():
	self.queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if !blasted:
		if area.is_in_group("bullet"):
			self.blast()
			blasted = true
	pass # Replace with function body.
