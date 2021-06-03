extends KinematicBody2D
class_name Player

var linear_vel = Vector2.ZERO
var SPEED = 400
var SPEED_SQUARED = SPEED * SPEED
var facing = "idle"
onready var playback = $AnimationTree.get("parameters/playback")
var can_kick = true
var flash_mode = false
var blink_mode = false


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

func _physics_process(delta: float) -> void:
	print(index)
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
		SPEED = 600
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
	if Input.is_action_just_pressed("kick") and can_kick:
		playback.travel("patada")
		print("just kick")
		pega_patada()
#		can_kick = false
		$Timer.start()
		return
	if Input.is_action_just_pressed("muerto"):
		print("presiona M de muerto")
		playback.travel("muerto")
		return
	if Input.is_action_just_pressed("move_right"):
		$Sprite.flip_h = false
	if Input.is_action_just_pressed("move_left"):
		$Sprite.flip_h = true
#	if Input.is_action_just_pressed("move_up") and facing != "up":
#		facing = "up"
#		playback.travel("right")
#	if Input.is_action_just_pressed("move_down") and facing != "down":
#		facing = "down"
#		playback.travel("right")
#	if abs(linear_vel.x) < 5 and abs(linear_vel.y) < 5:
#		facing = "idle"
#		playback.travel("idle")
	if(abs(linear_vel.x) < 5 && abs(linear_vel.y) < 5):
		playback.travel("idle")
	if(abs(linear_vel.x) >= 5 || abs(linear_vel.y) >= 5):
		playback.travel("right")
#	else:
#		playback.travel("right")
	
	print("X:",  abs(linear_vel.x))
	print("Y:",  abs(linear_vel.y))
	print("patadas:",  patadas)
	#print(linear_vel);

func _on_Timer_timeout():
	print("can kick")
	can_kick = true
	
func on_flashtime_out():
	flash_mode = false
	
func on_blinktime_out():
	blink_mode = false

func set_text(text):
	$Sprite.texture = text
	

func pega_patada():
	patadas += 1
	var node = get_parent().get_node("IntefazPuntaje")
	print("label:",  node)

