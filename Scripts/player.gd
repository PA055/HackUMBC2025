extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "roll"
	$AnimatedSprite2D.play()
	pass
@export var velocityMultiplier: float = 1
@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sprite = $AnimatedSprite2D
	
	

	boostCooldownLeft -= delta;
	if sprite.animation != "roll":
		sprite.animation = "roll"
	sprite.play()

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);

func _physics_process(delta: float) -> void:
	print("position")
	
