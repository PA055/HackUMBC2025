extends RigidBody2D

@export var velocityMultiplier: float = 1
@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;

func _ready() -> void:
	$AnimatedSprite2D.play("transition");

func _process(delta: float) -> void:
	boostCooldownLeft -= delta;
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.rotate(8 * delta)

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0 and body is CharacterBody2D:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);

func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "transition" && $AnimatedSprite2D.frame == 5:
		$AnimatedSprite2D.stop();
