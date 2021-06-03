extends Node2D


# Declare member variables here. Examples:
var Diamond = preload("res://scenes/Diamond.tscn")
var Raichu = preload("res://scenes/Raichu.tscn")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Timer.connect("timeout", self, "on_time_out")
	
func spawn_powerup():
	if randf() > 0.5:
		add_diamond()
	else:
		add_raichu()

func add_diamond():
	var diamond = Diamond.instance()
	diamond.position = Vector2(1024*randf(), 600*randf())
	add_child(diamond)
	
func add_raichu():
	var raichu = Raichu.instance()
	raichu.position = Vector2(1024*randf(), 600*randf())
	add_child(raichu)

func on_time_out():
	spawn_powerup()
	$Timer.wait_time = 5 + 15*randf()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
