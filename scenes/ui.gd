extends CanvasLayer

func _ready():
	get_tree().paused = false
	$pause/ColorRect.hide()
	$unlock/ColorRect.hide()
	$failed/ColorRect.hide()
	

func _unhandled_key_input(event):
	if event.is_action_released("space"):
		$pause/ColorRect.show()
		get_tree().paused = true 
		


func _on_continue_pressed():
	get_tree().paused = false
	$pause/ColorRect.hide()
	$unlock/ColorRect.hide()


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menu.tscn")
	
func failed():
	$failed/ColorRect.show()
	
func unlock():
	$unlock/ColorRect.show()


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Level.tscn")
