extends Area2D

var flash_timer

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	$Timer.connect("timeout", self, "on_time_out")
	
func on_time_out():
	queue_free()

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		var player: Player = body
		player.flash_mode = true
		player.get_node("FlashTimer").start()
		queue_free()
		

