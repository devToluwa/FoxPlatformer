extends CharacterBody2D

class_name Player

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

const FALLEN_OFF: float = 200.0
const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL_SPEED: float = 400.0
const JUMP_VELOCITY: float = -260
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0.0, -130.0)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $"Debug Label"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter
@onready var invincible_timer: Timer = $"Invincible Timer"
@onready var hurt_timer: Timer = $"Hurt Timer"
@onready var invincible_player: AnimationPlayer = $"Invincible Player"
@onready var player_audio: AudioStreamPlayer2D = $player_audio
@onready var player_cam: Camera2D = $"Player Cam"

var _current_state: PlayerState = PlayerState.IDLE
var _invincible: bool = false

@export var _lives: int = 5


func _ready() -> void:
	call_deferred("late_setup")

func late_setup() -> void:
	SignalManager.on_level_started.emit(_lives)

func set_camera_limits(lim_min: Vector2, lim_max: Vector2) -> void:
	player_cam.limit_bottom = lim_min.y
	player_cam.limit_top = lim_max.y
	player_cam.limit_left = lim_min.x
	player_cam.limit_right = lim_max.x

func _physics_process(delta: float) -> void:
	
	fallen_off()
	
	if is_on_floor_only() == false:
		velocity.y += GRAVITY * delta
		
	get_inputs()
	
	move_and_slide()
	calculate_states()
	update_debug_label()

func fallen_off() -> void:
	if global_position.y < FALLEN_OFF: return
	reduce_lives(_lives)

func update_debug_label():
	debug_label.text = "floor: %s, inv: %s\nstate: %s\nvel:(%.0f, %.0f)\nhp_status: %d" % [
		is_on_floor(),
		_invincible,
		PlayerState.keys()[_current_state],
		velocity.x,
		velocity.y, _lives]

func shoot() -> void:
	#var direction_to_shoot: Vector2
	if sprite_2d.flip_h: shooter.shoot(Vector2.LEFT)
	else: shooter.shoot(Vector2.RIGHT)

func get_inputs() -> void:
	
	if _current_state == PlayerState.HURT: return 
	
	velocity.x = 0
	
	# Moving
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(player_audio, SoundManager.SOUND_JUMP)
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED) # clamping how fast we fall
	
	if Input.is_action_just_pressed("shoot"): shoot()

func set_states(new_state: PlayerState) -> void:
	
	if new_state == _current_state: return
	
	if _current_state == PlayerState.FALL:
		if new_state == PlayerState.IDLE or new_state == PlayerState.RUN:
			SoundManager.play_clip(player_audio, SoundManager.SOUND_LAND)
	
	_current_state = new_state
	
	match _current_state:
		PlayerState.IDLE: animation_player.play("idle")
		PlayerState.RUN: animation_player.play("run")
		PlayerState.JUMP: animation_player.play("jump")
		PlayerState.FALL: animation_player.play("fall")
		PlayerState.HURT: apply_hurt_jump()

func calculate_states() -> void:
	
	if _current_state == PlayerState.HURT: return 
	
	if is_on_floor():
		if velocity.x == 0:
			set_states(PlayerState.IDLE)
		else:
			set_states(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_states(PlayerState.FALL)
		else:
			set_states(PlayerState.JUMP)

func reduce_lives(lives_reduced: int) -> bool:
	_lives -= lives_reduced
	SignalManager.on_player_hit.emit(_lives)
	if _lives <= 0:
		animation_player.stop()
		SignalManager.on_game_over.emit()
		set_physics_process(false)
		animation_player.stop()
		invincible_player.stop()
		print("YOU DIED!!")
		return false
	return true

func go_invincible() -> void:
	_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()

func apply_hurt_jump() -> void:
	animation_player.play("hurt")
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()

func apply_hit() -> void:
	if _invincible: return
	if reduce_lives(1) == false: return
	SoundManager.play_clip(player_audio, SoundManager.SOUND_DAMAGE)
	go_invincible()
	set_states(PlayerState.HURT)

func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()


func _on_hit_box_area_entered(_area: Area2D) -> void:
	apply_hit()


func _on_hurt_timer_timeout() -> void:
	set_states(PlayerState.IDLE)
	pass # Replace with function body.
