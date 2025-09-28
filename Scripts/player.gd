extends RigidBody2D

<<<<<<< HEAD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "roll"
	$AnimatedSprite2D.play()
	pass
=======
@export var velocityMultiplier: float = 1
@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;
>>>>>>> 0c007c789d03a11111afc1b3a1fde8698f9da784

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
<<<<<<< HEAD
	var sprite = $AnimatedSprite2D
	#if sprite.animation != "roll":
		#sprite.animation = "roll"
		#sprite.play()
	
	
	#if sprite.frame == sprite.sprite_frames.get_frame_count("roll") - 1:
	#	sprite.stop() 
	
	
=======
	boostCooldownLeft -= delta;
	var sprite = $AnimatedSprite2D;
	if sprite.animation != "roll":
		sprite.animation = "roll"
		sprite.play()
>>>>>>> 0c007c789d03a11111afc1b3a1fde8698f9da784

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);
