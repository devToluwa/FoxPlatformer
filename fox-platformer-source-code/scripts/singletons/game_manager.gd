extends Node

const MAIN_MENU = preload("res://scenes/levels/main_menu.tscn")
const TOTAL_LEVELS: int = 4

var _level_scenes: Dictionary = {  }
var _current_level: int = 0

func _ready() -> void:
	for level_number in range(1, TOTAL_LEVELS + 1):
		_level_scenes[level_number] = load("res://scenes/levels/level_%d.tscn" % level_number)
	print(_level_scenes)

func load_main_scene() -> void:
	_current_level = 0
	ScoreManager.reset_score()
	get_tree().change_scene_to_packed(MAIN_MENU)

func load_next_level_scene() -> void:
	set_next_level()
	get_tree().change_scene_to_packed(_level_scenes[_current_level])

func set_next_level():
	_current_level += 1
	if _current_level > TOTAL_LEVELS: _current_level = 1
