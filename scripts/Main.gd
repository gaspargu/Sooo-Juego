extends Node2D

var Player = preload("res://scenes/Player.tscn")



func _ready() -> void:
	
	Game.connect("player_disconnected", self, "_end_game_id")
	Game.connect("server_disconnected", self, "_end_game")
	
	
	
	for nid in Game.players.keys():
		var player = Player.instance()
		player.init(nid)
		player.global_position = $Positions.get_child(Game.players[nid]["slot"]).global_position
		#player.set_text($Textures/Sprite2.texture)
		player.set_text($Textures.get_child(Game.players[nid]["slot"]).texture)
		$Players.add_child(player)
		

func _end_game_id(id):
	_end_game()

func _end_game():
	Game.call_deferred("end_game")
	get_tree().change_scene("res://scenes/Lobby.tscn")
	

 

