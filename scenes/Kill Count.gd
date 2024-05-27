extends Label
onready var level = get_node("/root/Level/")

func show_kills():
	text = "Kills:" + str(level._get_points())
