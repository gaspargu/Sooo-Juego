extends Area2D
var player_Inside = false
var started = false

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.is_Soo:
			player_Inside = true
	else:
		print("uwu")

func on_body_exited(body: Node):
	if body.is_in_group("player"):
		if body.is_Soo:
			player_Inside = false
			started = true
