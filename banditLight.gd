extends KinematicBody2D

# Declare member variables here. Examples:
var health : float = 7.0
var LBandit_damage : float = 2.0
var LBandit_attacking : bool = false
var LBandit_gravity : int = 1000
var LBandit_jumpforce : int = 200
var LBandit_speed : int = 150
var LBandit_detected : bool = false
var LBandit_vel = Vector2(0,0)
var LBandit_invul : bool = false
var pc = null
var rng = RandomNumberGenerator.new()
var randomNumber = null
onready var LBanditsprite : AnimatedSprite = get_node("AnimatedSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")
	pc = get_node("/root/MainScene/PlayerCharacter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	LBandit_vel.y = LBandit_gravity * delta
	rng.randomize()
	randomNumber = rng.randi_range(1,10)
	logic()

func logic():
	if health >= health*0.4 and LBandit_attacking == false and LBandit_detected == true:
		LBandit_speed = 100
		if pc:
			var direction = (pc.position - self.position).normalized()
			if LBandit_attacking == false and LBandit_detected == true:
				# warning-ignore:return_value_discarded
				LBandit_vel = move_and_slide(Vector2(direction.x,0) * LBandit_speed)
			if direction.x < 0:
				LBanditsprite.flip_h = false
				$AnimatedSprite.play("run")
				yield($AnimatedSprite, "animation_finished")
				$field_of_vision/DetectionCollision.position = Vector2(-357.5, 0)
				$AttackHitbox/AttackCollision.position = Vector2(-17,0)
			elif direction.x > 0:
				LBanditsprite.flip_h = true
				$AnimatedSprite.play("run")
				yield($AnimatedSprite, "animation_finished")
				$field_of_vision/DetectionCollision.position = Vector2(357.5, 0)
				$AttackHitbox/AttackCollision.position = Vector2(17,0)
	elif health < health*0.4 and LBandit_attacking == false and LBandit_detected == true:
		LBandit_speed = 35
		if randomNumber < 4:
			pass
		else: 
			if pc:
				var direction = (pc.position - self. position).normalized()
				if LBandit_attacking == false:
				# warning-ignore:return_value_discarded
					LBandit_vel = move_and_slide(Vector2(direction.x,0) * LBandit_speed)
				if direction.x < 0:
					LBanditsprite.flip_h = false
					$AnimatedSprite.play("run")
					yield($AnimatedSprite, "animation_finished")
					$field_of_vision/DetectionCollision.position = Vector2(-357.5, 0)
					$AttackHitbox/AttackCollision.position = Vector2(-17,0)
				elif direction.x > 0:
					LBanditsprite.flip_h = true
					$AnimatedSprite.play("run")
					yield($AnimatedSprite, "animation_finished")
					$field_of_vision/DetectionCollision.position = Vector2(357.5, 0)
					$AttackHitbox/AttackCollision.position = Vector2(17,0)

func attack():
	$AnimatedSprite.stop()
	LBandit_attacking = true
	LBandit_vel.x = 0
	$AnimatedSprite.play("attack")
	$AttackHitbox/AttackCollision.set_deferred("disabled", false)
	yield($AnimatedSprite,"animation_finished")
	LBandit_attacking = false
	$AttackHitbox/AttackCollision.set_deferred("disabled", true)

func die():
	LBandit_vel.x = 0
	$field_of_vision/DetectionCollision.set_deferred("disabled", true)
	$AttackHitbox/AttackCollision.set_deferred("disabled", true)
	$AnimatedSprite.stop()

	$AnimatedSprite.play("dying")
	yield($AnimatedSprite, "animation_finished")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "dying":
		queue_free()
	if $AnimatedSprite.animation == "hurt":
		pass

func _on_IFrameTimer_timeout():
	LBandit_invul = false
	if $AnimatedSprite.animation == "hurt":
		yield($AnimatedSprite, "animation_finished")

func _on_field_of_vision_body_entered(body):
	if body.is_in_group("Player"):
		LBandit_detected = true
		$field_of_vision/DetectionCollision.set_deferred("disabled", true)

func _on_field_of_vision_body_exited(body):
	if body.is_in_group("Player"):
		#LBandit_detected = false
		pass
		
func _on_MeleeRange_body_entered(body):
	if body.is_in_group("Player"):
		LBandit_attacking = true
		attack()

func _on_EnemyBody_area_entered(area):
	if area.is_in_group("Sword"):
		$IFrameTimer.start()
		if LBandit_invul == false:
			health -= pc.damage
			print(health)
			LBandit_invul = true
		if health > 0:
			LBandit_vel = Vector2(0,0)
			$AnimatedSprite.stop()
			$AnimatedSprite.play("hurt")
			yield($AnimatedSprite, "animation_finished")
		if health < 1:
			die()
