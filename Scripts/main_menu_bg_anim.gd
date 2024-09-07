extends Node2D

@onready var planes_path_follow = get_node("1/Path2D/PathFollow2D")
var initial_points = []
var intermediate_rect : Rect2i
var dir
var speed = 100
@onready var timer = get_node("Timer")
@onready var celestial_objects = get_node("2")
var ast_1 = preload("res://Scenes/asteroid1.tscn")

var stop = false
var intermediate_point : Vector2
var curve2d
var initial_pos
var second_path_enabled = false

var initial_ast = false

func _ready():
	intermediate_rect.position = Manager.win_size/4
	intermediate_rect.size = Manager.win_size/2
#	Manager.set_scale(planes_path_follow.get_child(0))
	set_initial_points()
	generate_random_intermediate_point_and_direction()
	set_curve()
	spawn_asteroids()
	spawn_celestial_obj()


func spawn_celestial_obj():
	var timer  = Timer.new()
	timer.wait_time = 20
	timer.one_shot = false
	timer.autostart = true
	
	self.add_child(timer)
	timer.timeout.connect(spawn_asteroids)
		
func spawn_asteroids():
	var ast_no = randi_range(2, 4)
	if not initial_ast:
		for ast in ast_no:
			var a = ast_1.instantiate()
			var ast_scale =randf_range(.01, 0.8)
			a.scale.x = ast_scale
			a.scale.y = ast_scale
#			Manager.set_scale(a)
			a.rotation_degrees = randi_range(0, 90)
			a.position = Vector2(randf_range(0, Manager.win_size.x), randf_range(0, Manager.win_size.y))
			a.final_point = initial_points.pick_random()
			a.direction = a.position.direction_to(a.final_point)
			a.dirn_specified = true
			celestial_objects.add_child(a)
		initial_ast = true
	if initial_ast:
		for ast in ast_no:
			var a = ast_1.instantiate()
			var ast_scale =randf_range(.01, 0.8)
			a.scale.x = ast_scale
			a.scale.y = ast_scale
#			Manager.set_scale(a)			
			a.rotation_degrees = randi_range(0, 90)
			a.position = initial_points.pick_random()
			a.final_point = initial_points.pick_random()
			a.direction = a.position.direction_to(a.final_point)
			a.dirn_specified = true
			celestial_objects.add_child(a)
	pass
func re_run():
	curve2d.clear_points()
	planes_path_follow.progress = 0
	set_initial_points()
	generate_random_intermediate_point_and_direction()
	set_curve()
	
func set_curve():
	initial_pos =initial_points.pick_random()
	curve2d = Curve2D.new()
	curve2d.bake_interval = 100
	curve2d.add_point(initial_pos)
	curve2d.add_point(intermediate_point)
	planes_path_follow.get_parent().curve = curve2d
	
func _physics_process(delta):
	move_planes(delta)
	
func move_planes(delta):
	planes_path_follow.progress += delta*speed
	if not second_path_enabled and planes_path_follow.progress_ratio >= .991:
		speed = 0
		set_second_path()
		wait_and_move()
		second_path_enabled = true
	
	if second_path_enabled and planes_path_follow.progress_ratio >=.991:
		second_path_enabled = false
		re_run()
		
		
func wait_and_move():
	timer.start()
	timer.timeout.connect(move)

func move():
	speed = 100
	
	
func set_second_path():
	var sec_pos = initial_points.pick_random()
	curve2d.add_point(sec_pos)

	
func generate_random_intermediate_point_and_direction():
	while not intermediate_rect.has_point(intermediate_point):
		var x = randi_range(0, Manager.win_size.x)
		var y = randi_range(0, Manager.win_size.y)
		intermediate_point = Vector2(x, y)
	return intermediate_point
	
func set_initial_points():
	for vertical in range(-300, Manager.win_size.y+200):
		initial_points.push_back(Vector2(-300,vertical))
		initial_points.push_back(Vector2(Manager.win_size.x+300, vertical))
	for horizontal in range(-300, Manager.win_size.x+300):
		initial_points.push_back(Vector2(horizontal, -300))
		initial_points.push_back(Vector2(horizontal, Manager.win_size.y+300))
