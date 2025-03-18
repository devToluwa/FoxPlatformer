extends Control

const HIGHSCORE_LABEL = preload("res://scenes/UI Stuff/highscore_label.tscn")

@onready var grid_container: GridContainer = $MC/GridContainer

func _ready() -> void:
	set_scores()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()

func set_scores() -> void:
	for c in grid_container.get_children():
		grid_container.remove_child(c)
	for each_score in ScoreManager.get_score_history():
		var label: Label = HIGHSCORE_LABEL.instantiate()
		label.text = "%04d" % each_score
		grid_container.add_child(label)
