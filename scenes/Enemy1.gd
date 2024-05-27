extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
const obj_bullet = preload("res://scenes/EnemyBullets.tscn")
onready var player = get_node("/root/Level/Player")
var velocity = Vector2()
var direction_x = 0
var direction_y = 0
export var health = 10

onready var shoot_timer = $ShootTimer
onready var rotator = $Rotator
const rotate_speed = 100
const shooter_timer_wait_time = 1
const spawn_point_count = 5
const radius = 100


func _ready():
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step*i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()
#func set_player(player_reference = owner.find_node("Player")):
#	player = player_reference
#func _ready():
#	set_player()
func _physics_process(delta):
	velocity.x = speed*direction_x
	velocity.y = speed*direction_y
	move_and_slide(velocity, Vector2.UP)
	
	if global_position.x < player.global_position.x:
		direction_x= 1
	if global_position.x > player.global_position.x:
		direction_x= -1
	if global_position.y > player.global_position.y:
		direction_y = -1
	if global_position.y < player.global_position.y:
		direction_y = 1
		
	
	var new_rotation = rotator.rotation_degrees +rotate_speed*delta
	rotator.rotation_degrees = fmod(new_rotation, 360)
# Called when the node enters the scene tree for the first time.
func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().get_child(new_bullet)


onready var Area_ = get_node("Area2D")
onready var AreaDefault = get_node("Area2D").get_scale()


func _on_Area2D_body_entered(body):
	Area_.set_scale(AreaDefault*2)
	pass # Replace with function body
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		health -= 1
		if health == 0:
			queue_free()
			
	if area.is_in_group("player_melee"):
		health -= 10
		if health == 0:
			queue_free()

func _exit_tree():
	get_tree().current_scene._add_points()

func take_damage(damage = 1):
	health -= damage
	print("health:" + str(health))
	if health <= 0:
		queue_free()

func _on_ShootTimer_timeout() -> void:
	for s in rotator.get_children():
		var bullet = obj_bullet.instance()
		get_tree().root.add_child(bullet)
		
		bullet.position = s.global_position
		bullet.rotation_degrees = s.rotation_degrees

		
	
