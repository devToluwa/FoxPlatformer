extends AnimatableBody2D

@export var destination: Marker2D
@export var speed: float = 50.0

var _start_position: Vector2
var _end_position: Vector2
var _time_to_move: float = 0.0
var _tween: Tween

func _ready() -> void:
	_start_position = global_position
	_end_position = destination.global_position
	
	var distance: float = _start_position.distance_to(_end_position)
	_time_to_move = distance / speed
	
	set_moving()

func _exit_tree() -> void: if _tween: _tween.kill()

func set_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops(0)
	_tween.tween_property(self, "global_position", _end_position, _time_to_move)
	_tween.tween_property(self, "global_position", _start_position, _time_to_move)
