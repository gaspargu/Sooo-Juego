extends Area2D

var started = false
var player_Inside = true

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func _on_Base_body_exited(body: Node):
	player_Inside = false
	started = true

func _on_Base_body_entered(body):
	if body.is_in_group("player"):
		player_Inside = true
		print("owo")
	else:
		print("uwu")
