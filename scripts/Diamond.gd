extends Area2D


func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	$Timer.connect("timeout", self, "on_time_out")
	
func on_time_out():
	queue_free()

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		queue_free()
		

