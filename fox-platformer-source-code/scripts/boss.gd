extends Node2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@export var lives: int = 2
@export var points: int = 5

@onready var visuals: Node2D = $Visuals

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var hitbox: Area2D = $Visuals/Hitbox

var _invincible: bool = false
#var _tween: Tween

func _ready() -> void:
	hitbox.monitoring = false

func tween_hit() -> void:
	var tween: Tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(visuals,"position", Vector2.ZERO, 1.0)

func set_invincible(value: bool) -> void:
	_invincible = value
	if value == true:
		state_machine.travel("hit")

func reduce_lives():
	lives -= 1
	if lives <= 0:
		lives = 0
		SignalManager.on_boss_killed.emit(points)
		#_tween.kill()
		queue_free()

func take_damage() -> void:
	if _invincible: return
	else: 
		set_invincible(true)
		tween_hit()
		reduce_lives()

func _on_trigger_area_entered(_area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true
	hitbox.monitoring = true


func _on_hitbox_area_entered(_area: Area2D) -> void:
	take_damage()	
