extends Camera2D

@onready var shake_timer: Timer = $"Shake Timer"

@export var shake_amount: float = 5.0

func _ready() -> void:
	set_process(false)
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_game_over.connect(on_game_over)

func _process(_delta: float) -> void:
	offset = get_random_offset()

func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)

func reset_camera() -> void:
	set_process(true)
	shake_timer.start()

func _on_shake_timer_timeout() -> void:
	set_process(false)
	offset = Vector2.ZERO
	shake_timer.stop()
	pass # Replace with function body.

func on_game_over() -> void:
	reset_camera()

func on_player_hit(_lives: int):
	set_process(true)
	shake_timer.start()
