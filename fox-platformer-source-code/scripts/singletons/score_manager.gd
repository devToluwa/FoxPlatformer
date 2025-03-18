extends Node

const SCORE_FILE: String = "user://FoxyScores.json"
const MAX_SCORES: int = 10

var _score: int = 0
var _scores_history: Array = []

func _ready() -> void:
	SignalManager.on_enemy_hit.connect(update_score)
	SignalManager.on_pickup_hit.connect(update_score)
	SignalManager.on_boss_killed.connect(update_score)
	SignalManager.on_game_over.connect(on_game_over)
	load_scores_history()

func get_score_history() -> Array[int]:
	var highscore_list: Array[int] = []
	for each_score in _scores_history.slice(0, MAX_SCORES):
		if each_score.score != 0:
			highscore_list.push_back(int(each_score.score))
	return highscore_list

func update_score(points: int) -> void:
	_score += points
	SignalManager.on_score_updated.emit(_score)

func get_score() -> int:
	return _score

func reset_score():
	_score = 0 

func on_game_over() -> void:
	_scores_history.append({"score": _score})
	save_scores()

func compare_scores(a, b) -> int:
	return b.score < a.score

func save_scores() -> void:
	_scores_history.sort_custom(compare_scores)
	var file = FileAccess.open(SCORE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_scores_history.slice(0, MAX_SCORES)))
		file.close()

func load_scores_history():
	_scores_history.clear()
	var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		if text and text.length() > 0:
			_scores_history = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		save_scores()
	_scores_history.sort_custom(compare_scores)
	print("hello")
	print(_scores_history)
