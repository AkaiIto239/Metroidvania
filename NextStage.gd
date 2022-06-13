tool
extends Area2D

export(String, FILE) var nextScene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_NextStage_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://BossLevel.tscn")
