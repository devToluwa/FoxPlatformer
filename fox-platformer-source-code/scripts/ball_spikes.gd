extends PathFollow2D

@export var speed: float = 0.05
@export var rotation_speed: float = 400.0

func _process(delta: float) -> void:
	progress_ratio += delta * speed
	rotation_degrees += rotation_speed * delta
