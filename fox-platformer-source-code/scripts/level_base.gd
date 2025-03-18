extends Node2D

@export var camera_min: Vector2
@export var camera_max: Vector2

@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_level_complete.connect(on_game_over)
	#player.set_camera_limits(camera_min, camera_max)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance"):
		GameManager.load_next_level_scene()
	if Input.is_action_just_pressed("go back"):
		GameManager.load_main_scene()

func on_game_over() -> void:
	for moveables in get_tree().get_nodes_in_group(Constants.MOVEABLES):
		moveables.set_process(false)
		moveables.set_physics_process(false)
