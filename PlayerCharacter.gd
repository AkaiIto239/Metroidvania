extends KinematicBody2D

var health : float = 10.0
var damage : float = 3.0
var speed : int = 150
var jumpForce : int = 250
var gravity : int = 500
var attacking : bool = false
var attackNum : int = 1
var attackAnim = null
var vel = Vector2()
onready var sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var lb = get_node("/root/MainScene/Enemy")

func _ready():
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	#movement section
	vel.x = 0
	vel.y += gravity * delta
	attackAnim = "LightAttack" + str(attackNum)
	
	if attacking == false:
		if Input.is_action_pressed("move_left"):
			vel.x = -speed
			sprite.position = Vector2(-24,0)
			$Hitbox.position = Vector2(-52,-13)
			$AnimatedSprite.play("Run")
		elif Input.is_action_pressed("move_right"):
			vel.x = speed
			sprite.position = Vector2(0,0)
			$Hitbox.position = Vector2(-12,-13)
			$AnimatedSprite.play("Run")
		else:
			if attacking == false:
				vel.x = 0
				$AnimatedSprite.play("Idle")

	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
	#movement section end
	
	#jump section
	if attacking == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			vel.y -= jumpForce
		
		if Input.is_action_just_pressed("jump") and is_on_wall():
			vel.y -= jumpForce
	#jump section end
	
	#movement object
	vel = move_and_slide(vel, Vector2.UP)
	
	#combat section
	if attacking == false:
		if Input.is_action_just_pressed("melee_attack"):
			$Timer.start()
			attack()
			if $Timer.time_left > 0:
				attackNum += 1
			if attackNum == 4:
				attackNum = 1
	#combat section end

func attack():
	attacking = true
	vel.x = 0
	$AnimatedSprite.play(attackAnim)
	$Hitbox/AttackHitbox.set_deferred("disabled", false)
	if sprite.flip_h == false:
		self.position += Vector2(2,0)
	else:
		self.position -= Vector2(2,0)
	yield($AnimatedSprite,"animation_finished")
	attacking = false
	$Hitbox/AttackHitbox.set_deferred("disabled", true)
	

func _on_Timer_timeout():
	attackNum = 1


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "LightAttack1":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Idle")
	if $AnimatedSprite.animation == "LightAttack2":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Idle")
	if $AnimatedSprite.animation == "LightAttack3":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Idle")
	#if $AnimatedSprite.animation == "Run":
	#	$AnimatedSprite.stop()
	#	$AnimatedSprite.play("Idle")


func _on_PlayerHitbox_body_entered(body):
	if body.is_in_group("LBanditSword"):
		health -= lb.LBandit_damage
		print(health)
