extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "roll"
	$AnimatedSprite2D.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
var frameIndex :int=0;
func _process(delta: float) -> void:
	var sprite = $AnimatedSprite2D
	#if sprite.animation != "roll":
		#sprite.animation = "roll"
		#sprite.play()
	
	
	#if sprite.frame == sprite.sprite_frames.get_frame_count("roll") - 1:
	#	sprite.stop() 
	
	

func _on_momentum_collider_area_entered(area: Area2D) -> void:
	print("collided with move? ", area.name);
	apply_central_force(area.next_velocity())
	
func _on_momentum_collider_body_entered(body: Node2D) -> void:
	pass
