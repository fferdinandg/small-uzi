extends Node2D


onready var camera = get_parent()
var time = 0

func _shake(duration = 0.8, magnitude = 8):
	while time < duration:
		time += get_process_delta_time()
		time = min(time,duration)
		var offset = Vector2()
		offset.x = rand_range(-magnitude, magnitude)
		offset.y = rand_range(-magnitude, magnitude)
		camera.set_offset(offset)
		yield(get_tree(),"idle_frame")
	time = 0
	camera.set_offset(Vector2.ZERO)
