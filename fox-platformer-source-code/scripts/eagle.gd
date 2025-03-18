extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooter: Shooter = $Shooter
@onready var player_dectector: RayCast2D = $"Player Dectector"
@onready var direction_timer: Timer = $"Direction Timer"

const FLY_SPEED: Vector2 = Vector2(35, 15)

var _fly_direction: Vector2 = Vector2.ZERO # (-1, 1) or (1, 1)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	shoot()

func shoot() -> void:
	if player_dectector.is_colliding():
		shooter.shoot(global_position.direction_to(_player_reference.global_position))

func fly_to_player() -> void:
	var x_dir = sign(_player_reference.global_position.x - global_position.x)
	if x_dir > 0: animated_sprite_2d.flip_h = true
	else: animated_sprite_2d.flip_h = false
	_fly_direction = Vector2(x_dir, 1) * FLY_SPEED

func _on_direction_timer_timeout() -> void:
	fly_to_player()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	direction_timer.start()
	fly_to_player()
