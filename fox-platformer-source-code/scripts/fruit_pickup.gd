extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY: float = 160.0
const JUMP_AMOUNT: float = -120.0
const POINTS: int = 2

var _start_y: float
var _speed_y: float = JUMP_AMOUNT

func _ready() -> void:
	
	_start_y = position.y
	
	var fruit_names: Array[String] = []
	for fruit in anim.sprite_frames.get_animation_names():
		fruit_names.push_back(fruit)
	anim.animation = fruit_names.pick_random()

func _process(delta: float) -> void:
	position.y += _speed_y * delta
	_speed_y += (GRAVITY * 2.5) * delta
	
	if position.y > _start_y:
		set_process(false)

func kill_me() -> void:
	hide()
	queue_free()

func _on_life_timer_timeout() -> void:
	kill_me()


func _on_area_entered(_area: Area2D) -> void:
	SignalManager.on_pickup_hit.emit(POINTS)
	print("_on_area_entered")
	kill_me()
