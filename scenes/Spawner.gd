extends Node2D

var obstacle = preload("res://scenes/Enemy1.tscn")

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instance()
	get_parent().add_child(spawned)

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + rand_range(-1000, 50)

	spawned.global_position = spawn_pos

func repeat():
	spawn()
	yield(get_tree().create_timer(3), "timeout")
	repeat()
