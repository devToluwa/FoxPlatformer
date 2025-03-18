extends Area2D

class_name Bullet

var _direction: Vector2 = Vector2.RIGHT
var _lifespan: float = 50.0
var _lifetime: float = 0.0

func _process(delta: float) -> void:
	update_label()
	position += _direction * delta
	check_expired(delta)

func update_label() -> void:
	pass
	# add something later

func check_expired(delta: float) -> void:
	_lifetime += delta
	if _lifetime > _lifespan:
		queue_free()

func setup(pos: Vector2, direction: Vector2, speed: float, life_span: float):
	_direction = direction.normalized() * speed
	_lifespan = life_span
	global_position = pos


func _signal_on_area_entered(_area: Area2D) -> void:
	print("we triggered on area entered signal from bullet base")
	queue_free()
