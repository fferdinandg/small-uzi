extends KinematicBody2D

const UP = Vector2(0,-1)
onready var screenshake = $Camera2D/Screenshake
export var GRAVITY = 1200
export var direction = Vector2.ZERO
export var speed: int = 400
export var jump_speed: int = -600
export var health: int = 20
var has_melee = false;
var is_meleeing = false;
var kill_count = 0



var velocity: Vector2 = Vector2()

func _ready():
	$Melee/Sprite.visible = false
	$Melee/MeleeCollision.disabled = true
	

func get_input():
	velocity.x = 0
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_just_pressed("melee"):
		if kill_count >= 10:
			melee()


func _physics_process(_delta):
	velocity.y += _delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)
	


func _process(_delta):
	if velocity.y != 0 && is_meleeing == false:
		$AnimatedSprite.play("Jump")
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
			$Melee.position.x = 10
			$Melee/Sprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			$Melee.position.x = -150
			$Melee/Sprite.flip_h = true
	elif velocity.x != 0 && is_meleeing == false:
		$AnimatedSprite.play("Walk") 
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
			$Melee.position.x = 10
			$Melee/Sprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			$Melee.position.x = -150
			$Melee/Sprite.flip_h = true
	else:
		if is_meleeing == false:
			$AnimatedSprite.play("Idle")
		
func take_damage(damage = 1):
	health -= damage
	print("health:" + str(health))
	get_tree().current_scene._reduce_health()
	if health <= 0:
		kill()
		print("you lose")
			
func unlock():
	get_parent().unlock()

func kill():
	get_parent().failed()

func add_point():
	kill_count += 1
	print("kills: " + str(kill_count))
	if kill_count == 10:
		unlock()

func melee():
	$Melee/MeleeCollision.disabled = false
	$AnimatedSprite.play("Melee")
	is_meleeing = true
	
	$Melee/Sprite.visible = true

		
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Melee":
		is_meleeing = false
		$Melee/MeleeCollision.disabled = true

		$Melee/Sprite.visible = false
#		$Melee/Sprite.visible = not $Melee/Sprite.visible
		

func wait_for_seconds(seconds):
	print("Wait starts")
	# Create a timer and yield until it times out
	yield(get_tree().create_timer(seconds), "timeout")
	print("Wait ends")


#func _on_Melee_area_entered(area):
#	if area.is_in_group("enemy_bullet"):
#


func _on_DeathArea_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	kill()
