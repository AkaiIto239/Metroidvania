extends KinematicBody2D

var health :int = 10
var attack : int = 3
var speed : int = 100
var jumpForce : int = 300
var walljump : int = 250
var gravity : int = 400
var doublejump : bool = false

var vel = Vector2()
onready var sprite : AnimatedSprite = get_node("AnimatedSprite")

func _physics_process(delta):
	vel.x = 0
	sprite.centered = true
	
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
		sprite.offset = Vector2(-10,0)
		vel.x = -speed
		$AnimatedSprite.play("Run")

	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false
		vel.x = speed
		$AnimatedSprite.play("Run")

	if Input.is_action_just_released("move_right") and vel.x == 0:
		$AnimatedSprite.play("Idle")
	elif Input.is_action_just_released("move_left") and vel.x == 0:
		sprite.flip_h = true
		$AnimatedSprite.play("Idle")

	vel.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
	
	if Input.is_action_pressed("melee_attack"):
		$AnimatedSprite.play("LightAttack1")
	else:
		$AnimatedSprite.stop()
	if Input.is_action_just_released("melee_attack"):
		$AnimatedSprite.play("LightAttack2")

	elif Input.is_action_just_released("melee_attack"):
		if Input.is_action_pressed("melee_attack"):
			$AnimatedSprite.play("LightAttack3")


	vel = move_and_slide(vel, Vector2.UP)
	
	#if vel.x < 0:
	#	sprite.flip_h = true
	#elif vel.x > 0:
	#	sprite.flip_h = false
