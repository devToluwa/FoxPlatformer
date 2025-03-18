extends Node2D

const BULLET_PLAYER_SCENE_PRELOAD = preload("res://scenes/game_objects/bullets/bullet_player.tscn")
const BULLET_ENEMY_SCENE_PRELOAD = preload("res://scenes/game_objects/bullets/bullet_enemy.tscn")
const EXPLOSION_SCENE_PRELOAD = preload("res://scenes/game_objects/explosion.tscn")
const PICKUP_SCENE_PRELOAD = preload("res://scenes/game_objects/fruit_pickup.tscn")


const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: BULLET_PLAYER_SCENE_PRELOAD,
	Constants.ObjectType.BULLET_ENEMY: BULLET_ENEMY_SCENE_PRELOAD,
	Constants.ObjectType.EXPLOSION: EXPLOSION_SCENE_PRELOAD,
	Constants.ObjectType.PICKUP: PICKUP_SCENE_PRELOAD
}

func _ready() -> void:
	SignalManager.on_create_bullet.connect(on_create_bullet)
	SignalManager.on_create_object.connect(on_create_object)

func on_create_bullet(
	pos: Vector2,
	dir: Vector2,
	life_span: float,
	speed: float,
	ob_type: Constants.ObjectType) -> void:
		if !OBJECT_SCENES.has(ob_type): return
		var new_bullet: Bullet = OBJECT_SCENES[ob_type].instantiate()
		new_bullet.setup(pos, dir, speed, life_span)
		call_deferred("add_child", new_bullet)


func on_create_object(pos: Vector2, ob_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(ob_type): return
	var new_object = OBJECT_SCENES[ob_type].instantiate()
	new_object.position = pos
	call_deferred("add_child", new_object)
