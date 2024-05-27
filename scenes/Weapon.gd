extends Sprite


var can_fire = true
var bullet = preload("res://scenes/Bullets.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


func _physics_process(delta):
	position.x = lerp(position.x, get_parent().position.x+ 50, 0.5)
	position.y = lerp(position.y, get_parent().position.y + 30, 0.5)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()	
		bullet_instance.rotation = rotation + rand_range(0.1,0.1)
		get_parent().screenshake._shake(0.2,1.3)
		bullet_instance.global_position = $Muzzle.global_position
		get_parent().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(0.1), "timeout")
		can_fire = true
