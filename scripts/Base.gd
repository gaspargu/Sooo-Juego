extends Area2D

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		print("owo")
	else:
		print("uwu")
