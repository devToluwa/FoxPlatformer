extends Node2D

class_name Shooter

@onready var shoot_timer: Timer = $"Shoot Timer"
@onready var shoot_sound: AudioStreamPlayer2D = $"Shoot Sound"

@export var bullet_speed: float = 200.0
@export var bullet_life_span:float = 10.0
@export var shoot_delay:float = 0.7
@export var bullet_key: Constants.ObjectType

var _can_shoot:bool = true

func _ready() -> void:
	shoot_timer.wait_time = shoot_delay

func shoot(direction: Vector2) -> void:
	if !_can_shoot: return
	
	SignalManager.on_create_bullet.emit(
		global_position, direction, bullet_life_span, bullet_speed, bullet_key
	)
	_can_shoot = false
	shoot_timer.start()
	SoundManager.play_clip(shoot_sound, SoundManager.SOUND_LASER)

func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
