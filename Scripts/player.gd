extends RigidBody2D

@export var velocityMultiplier: float = 1

@export var recordPath: bool = false;
@export var pathWaypointCooldown: float = 0.05
var waypointCooldownLeft = 0;

@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;

func _ready() -> void:
	var file = FileAccess.open("res://Debug/path.txt", FileAccess.WRITE);
	if file: file.close();
	$AudioStreamPlayer2D.play();
	$AnimatedSprite2D.play("transition");

func _process(delta: float) -> void:
	boostCooldownLeft -= delta;
	waypointCooldownLeft -= delta;
	if recordPath and waypointCooldownLeft <= 0:
		var file: FileAccess;
		var fp = "res://Debug/path.txt"
		if FileAccess.file_exists(fp):
			file = FileAccess.open(fp, FileAccess.READ_WRITE);
			file.seek_end();
		else:
			file = FileAccess.open(fp, FileAccess.WRITE_READ)
		file.store_string(str(position) + "\n");
		file.close();
	
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.rotate(10 * delta)


func _input(event: InputEvent) -> void:
	if not recordPath:
		return;
		
	if event.is_action_pressed("ToggleRed"):
		var file: FileAccess;
		var fp = "res://Debug/path.txt"
		if FileAccess.file_exists(fp):
			file = FileAccess.open(fp, FileAccess.READ_WRITE);
			file.seek_end();
		else:
			file = FileAccess.open(fp, FileAccess.WRITE_READ)
		file.store_string("key: 1\n");
		file.close();
	
	if event.is_action_pressed("ToggleYellow"):
		var file: FileAccess;
		var fp = "res://Debug/path.txt"
		if FileAccess.file_exists(fp):
			file = FileAccess.open(fp, FileAccess.READ_WRITE);
			file.seek_end();
		else:
			file = FileAccess.open(fp, FileAccess.WRITE_READ)
		file.store_string("key: 2\n");
		file.close();
	
	if event.is_action_pressed("ToggleBlue"):
		var file: FileAccess;
		var fp = "res://Debug/path.txt"
		if FileAccess.file_exists(fp):
			file = FileAccess.open(fp, FileAccess.READ_WRITE);
			file.seek_end();
		else:
			file = FileAccess.open(fp, FileAccess.WRITE_READ)
		file.store_string("key: 4\n");
		file.close();

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0 and body is CharacterBody2D:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);

func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "transition" && $AnimatedSprite2D.frame == 5:
		$AnimatedSprite2D.stop();
