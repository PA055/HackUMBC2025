extends RigidBody2D

<<<<<<< HEAD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "roll"
	$AnimatedSprite2D.play()
	pass
=======
>>>>>>> efc2d24597d8e300a01111215c5a7aa10b5c2f24
@export var velocityMultiplier: float = 1
@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;

func _ready() -> void:
	$AnimatedSprite2D.play("transition");

func _process(delta: float) -> void:
<<<<<<< HEAD
	var sprite = $AnimatedSprite2D
	
	

	boostCooldownLeft -= delta;
	if sprite.animation != "roll":
		sprite.animation = "roll"
	sprite.play()
=======
	boostCooldownLeft -= delta;
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.rotate(8 * delta)
>>>>>>> efc2d24597d8e300a01111215c5a7aa10b5c2f24

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0 and body is CharacterBody2D:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);

<<<<<<< HEAD
func _physics_process(delta: float) -> void:
	print("position")
	
=======
func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "transition" && $AnimatedSprite2D.frame == 5:
		$AnimatedSprite2D.stop();
>>>>>>> efc2d24597d8e300a01111215c5a7aa10b5c2f24
