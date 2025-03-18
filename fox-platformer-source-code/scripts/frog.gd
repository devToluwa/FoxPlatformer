extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $"Jump Timer"

const JUMP_MIN_TIME: float = 2.0
const JUMP_MAX_TIME: float = 4.0
const JUMP_VELOCITY_X: float = 100
const JUMP_VELOCITY_Y: float = 150
const JUMP_VELOCITY_RIGHT: Vector2 = Vector2(JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)
const JUMP_VELOCITY_LEFT: Vector2 = Vector2(-JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)

var _can_jump: bool = false
var _has_seen_player: bool = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")

	apply_jump()
	move_and_slide()
	flip_me()

func flip_me() -> void:
	if(_player_reference.global_position.x > global_position.x and !animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = true
	elif(_player_reference.global_position.x < global_position.x and animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = false

func apply_jump() -> void:
	if !is_on_floor(): return
	if !_has_seen_player or !_can_jump: return
	if !animated_sprite_2d.flip_h:
		velocity = JUMP_VELOCITY_LEFT
	else:
		velocity = JUMP_VELOCITY_RIGHT
	_can_jump = false
	animated_sprite_2d.play("jump")
	start_timer()

func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_MIN_TIME, JUMP_MAX_TIME)
	jump_timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("seeing the player")
	_has_seen_player = true
	start_timer()


func _on_jump_timer_timeout() -> void:
	_can_jump = true
	pass # Replace with function body.
