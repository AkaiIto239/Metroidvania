extends KinematicBody2D

# Declare member variables here. Examples:
var BossHealth = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
