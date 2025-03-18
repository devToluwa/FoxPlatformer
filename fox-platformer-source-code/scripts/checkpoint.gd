extends Area2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var checkpoint_sound: AudioStreamPlayer2D = $checkpoint_sound

func _ready() -> void:
	monitoring = false
	sprite_2d.hide()
	SignalManager.on_boss_killed.connect(on_boss_killed)

func on_boss_killed(_points: int) -> void:
	animation_tree[TRIGGER_CONDITION] = true
	sprite_2d.show()
	monitoring = true
	SoundManager.play_clip(checkpoint_sound, SoundManager.SOUND_CHECKPOINT)


func _on_area_entered(_area: Area2D) -> void:
	SoundManager.play_clip(checkpoint_sound, SoundManager.SOUND_WIN)
	SignalManager.on_level_complete.emit()
