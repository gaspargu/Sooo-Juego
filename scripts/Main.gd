extends Node2D

var Player = preload("res://scenes/Player.tscn")
var soo = 0

func _ready() -> void:
	
	Game.connect("player_disconnected", self, "_end_game_id")
	Game.connect("server_disconnected", self, "_end_game")

	for nid in Game.players.keys():
		var player = Player.instance()
		player.init(nid)
		player.global_position = $Positions.get_child(Game.players[nid]["slot"]).global_position
		#player.set_text($Textures.get_child(Game.players[nid]["slot"]).texture)
		$Players.add_child(player)
	
	$Players.get_child(soo).setSoo(true)

func _physics_process(delta: float) -> void:
	
	if $Base.player_Inside and $Base.started:
		set_global_pos()
		$Base.started = false

func set_global_pos():
	var i = 0
	for player in $Players.get_children():
		player.global_position = $Positions.get_child(i).global_position
		i += 1
	$Players.get_child(soo).setSoo(false)
	soo = (soo + 1) % $Players.get_child_count()
	$Players.get_child(soo).setSoo(true)
	

func _end_game_id(id):
	_end_game()

func _end_game():
	Game.call_deferred("end_game")
	get_tree().change_scene("res://scenes/Lobby.tscn")


