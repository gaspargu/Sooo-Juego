extends Node2D


# Declare member variables here. Examples:
var Diamond = preload("res://scenes/Diamond.tscn")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_diamond()

func add_diamond():
	var diamond = Diamond.instance()
	diamond.position = Vector2(1024*randf(), 600*randf())
	self.add_child(diamond)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
