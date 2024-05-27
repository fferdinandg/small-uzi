extends Area2D


export var speed = 100
var velocity: Vector2 = Vector2()
var reflected = false

func _ready():
	set_as_toplevel(true)
	
	
func _process(delta):
	var direction_vector = Vector2.RIGHT.rotated(rotation) # Calculate direction based on rotation
	position += direction_vector * speed * delta

	
func _physics_process(delta):
	yield(get_tree().create_timer(0.01),"timeout")
	set_physics_process(false)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_EnemyBullets_body_entered(body):
	if body.get_name() == "Player" and reflected == false:
		body.take_damage(1)
		queue_free()
	if body.get_name() == "Enemy1":
		pass
	if body.get_name() == "Enemy1" and reflected == true:
		body.queue_free()
		queue_free()
	else:
		queue_free()

func _on_EnemyBullets_area_entered(area):
	if area.get_name() == "Melee":
		speed = -1*speed
		reflected = true
