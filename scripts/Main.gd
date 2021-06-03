extends Node2D

var Player = preload("res://scenes/Player.tscn")

var dict = {}
var NPlayers = 0
var soo = 0

func _ready() -> void:
	
	Game.connect("player_disconnected", self, "_end_game_id")
	Game.connect("server_disconnected", self, "_end_game")
	
	NPlayers = len(Game.players.keys())
	print("NPlayers: ", NPlayers)
	
	for nid in Game.players.keys():
		var player = Player.instance()
		player.init(nid)
		player.global_position = $Positions.get_child(Game.players[nid]["slot"]).global_position
		dict[Game.players[nid]["name"]] = Game.players[nid]["slot"]
		#player.set_text($Textures.get_child(Game.players[nid]["slot"]).texture)
		$Players.add_child(player)
		
	$Players.get_child(soo).set_Soo(true)

func _physics_process(delta: float) -> void:
	
	if $Base.player_Inside and $Base.started:
		$Players.get_child(soo).set_Soo(false)
		soo = (soo + 1) % NPlayers
		print(soo)
		set_global_pos()
		$TimerRonda.start()
		$Base.started = false
		get_tree().set_pause(true)		
		
func set_global_pos():
	$Players.get_child(soo).set_Soo(true)
	$Players.get_child(soo).global_position = $Positions.get_child(0).global_position
	var i = 1
	for player in $Players.get_children():
		if player.is_Soo:
			pass
		else:
			player.global_position = $Positions.get_child(i).global_position
			i += 1

func _end_game_id(id):
	_end_game()

func _end_game():
	Game.call_deferred("end_game")
	get_tree().change_scene("res://scenes/Lobby.tscn")
	
func _on_TimerRonda_timeout():
	get_tree().set_pause(false)
