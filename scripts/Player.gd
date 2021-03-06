extends KinematicBody2D
class_name Player

var linear_vel = Vector2.ZERO
var SPEED = 800
var SPEED_SQUARED = SPEED * SPEED
var facing = "idle"
var DICIENDO_SOO = false
onready var playback = $AnimationTree.get("parameters/playback")
var can_kick = true

var is_Soo = false

var flash_mode = false
var blink_mode = false
export var is_kicking = false 

var power = 0
var patadas = 0


# networking
puppet var puppet_pos = Vector2()
puppet var puppet_target_vel = Vector2()
var index = AudioServer.get_bus_index("record-bus")

func _ready() -> void:
	puppet_pos = position
	$FlashTimer.connect("timeout", self, "on_flashtime_out")
	$BlinkTimer.connect("timeout", self, "on_blinktime_out")
	
	

func init(nid):
	set_network_master(nid)
	var info = Game.players[nid]
	$Name.text = info["name"]
	name = str(nid)


func _process(delta):
	power = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("record-bus2"), 0)

func _physics_process(delta: float) -> void:
	# obtiene el nodo del texto del microfono de la barra superior
	var nodo_microfono_texto = get_node("/root/Main/PanelSuperior/Panel/microfono_texto")
	
	# si los el numero del microfono es bajo
	if(power > -30):
		# activa el modo SOOO
		DICIENDO_SOO = true
		
		# Aparece texto verde "Mic Detectado" en la barra superior
		nodo_microfono_texto.text = "Mic Detectado " + String(round(power + 30))
		nodo_microfono_texto.add_color_override("font_color", Color(0,1,0))
		
		# muestra el texto Soooo que grita el personaje
		$TextoSooPersonaje.show()

	else: #el sonido es bajo
		
		# aparece texto rojo "Mic Silencio" en la barra superior
		nodo_microfono_texto.text = "Mic Silencio " + String(round(power + 30))
		nodo_microfono_texto.add_color_override("font_color", Color(1,0,0))
		# oculta el texto Soooo que grita el personaje
		$TextoSooPersonaje.hide()
		
		# desactiva el modo SOOO
		DICIENDO_SOO = false
	
	
	var target_vel
	if is_network_master():
		target_vel = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
#		target_vel = target_vel.normalized()
		rset("puppet_target_vel", target_vel)
	else:
		target_vel = puppet_target_vel
		
	# Power Ups modes	
	if flash_mode:
		if DICIENDO_SOO:
			SPEED = 600
		else: 
			SPEED = 300
	else:
		if DICIENDO_SOO:
			SPEED = 300
		else: 
			SPEED = 200
	if blink_mode:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
	
	linear_vel = lerp(linear_vel, target_vel * SPEED, 0.8)
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	
	if is_network_master():
		rset_unreliable("puppet_pos", position)
	else:
		position = lerp(position, puppet_pos, 0.5)
		puppet_pos = position
		
	var current = playback.get_current_node()	
	# Animations

#	if Input.is_action_just_pressed("move_up") and facing != "up":
#		facing = "up"
#		playback.travel("right")
#	if Input.is_action_just_pressed("move_down") and facing != "down":
#		facing = "down"
#		playback.travel("right")
#	if abs(linear_vel.x) < 5 and abs(linear_vel.y) < 5:
#		facing = "idle"

#		playback.travel("idle")		
	if target_vel.x != 0:
		$AnimatedSprite.scale.x = 4*sign(target_vel.x)
		
	
	if not is_kicking:
		if(abs(linear_vel.x) < 5 && abs(linear_vel.y) < 5):
			playback.travel("idle")
		if(abs(linear_vel.x) >= 5 || abs(linear_vel.y) >= 5):
			playback.travel("right")
		

#	print("X:",  abs(linear_vel.x))
#	print("Y:",  abs(linear_vel.y))
	#print("patadas:",  patadas)
	#print("microfono: ", power)
	#print(linear_vel);

func _on_Timer_timeout():
	#print("can kick")
	can_kick = true
	
func on_flashtime_out():
	flash_mode = false
	
func on_blinktime_out():
	blink_mode = false

func set_text(text):
	$Sprite.texture = text
	
func set_Soo(doit: bool):
	is_Soo = doit
	$Name.uppercase = doit

func idle_mode():
	playback.travel("idle")

func _input(event):
	if not is_network_master():
		return
	if event.is_action_pressed("kick") and can_kick:
		rpc("pega_patada")
		return

		
	if event.is_action_pressed("muerto"):
		print("presiona M de muerto")
		playback.travel("muerto")
		return
	
remotesync func pega_patada():
	patadas += 1
	var node = get_parent().get_node("IntefazPuntaje")
	print("label:",  node)
	is_kicking = true
	playback.travel("patada")
	can_kick = false
	$Timer.start()
