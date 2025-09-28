extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var frameIndex :int=0;
func _process(delta: float) -> void:
	var sprite = $AnimatedSprite2D;
	if sprite.animation != "roll":
		sprite.animation = "roll"
		sprite.play()
	
	
	if sprite.frame == sprite.frames.get_frame_count("roll") - 1:
		sprite.stop()  # stops at last frame
	
	

func _on_momentum_collider_area_entered(area: Area2D) -> void:
	print("collided with move? ", area.name);
	apply_central_force(area.next_velocity())
	
	
