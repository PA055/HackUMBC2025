extends RigidBody2D

@export var velocityMultiplier: float = 1

@export var recordPath: bool = false;
@export var pathWaypointCooldown: float = 0.05
var waypointCooldownLeft = 0;

@export var boostCooldown: float = 0.75
var boostCooldownLeft = 0;

var started: int = -1;

func _ready() -> void:
	freeze = true;
	$AudioStreamPlayer2D.play();

func _on_body_entered(body: CollisionShape2D) -> void:
		if body.is_in_group("Goal"):
			print("level passed")
			position.x = 600
			position.y = 1200
			pass

func _process(delta: float) -> void:
	boostCooldownLeft -= delta;
	waypointCooldownLeft -= delta;
	if recordPath and started == 1 and waypointCooldownLeft <= 0:
		var file: FileAccess;
		var fp = "res://Debug/path.txt"
		if FileAccess.file_exists(fp):
			file = FileAccess.open(fp, FileAccess.READ_WRITE);
			file.seek_end();
		else:
			file = FileAccess.open(fp, FileAccess.WRITE_READ)
		file.store_string(str(position) + "\n");
		file.close();
	
	if started == 0:
		started = 1;
		var file = FileAccess.open("res://Debug/path.txt", FileAccess.WRITE);
		if file: file.close();
		$AnimatedSprite2D.play("transition");
	
	if $AnimatedSprite2D.animation == "transition" and not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.rotate(10 * delta)
	
	var bounds: Rect2 = $"../LevelLoader".bounds.grow(50);
	print(global_position);
	print(bounds);
	if not bounds.has_point(global_position):
		get_tree().reload_current_scene();

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
		
	if event.is_action_pressed("Reset"):
		get_tree().reload_current_scene();
		
	if started == -1 and event.is_action_pressed("Start"):
		started = 0;
		$AnimatedSprite2D.animation = "idle";
		set_deferred("freeze", false);

func _on_momentum_collider_body_entered(body: Node2D) -> void:
	if boostCooldownLeft <= 0 and body is CharacterBody2D:
		var force: Vector2 = body.next_velocity() * velocityMultiplier;
		if force.length_squared() > 0:
			boostCooldownLeft = boostCooldown;
		apply_central_force(force);

func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "transition" && $AnimatedSprite2D.frame == 5:
		$AnimatedSprite2D.stop();

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn");
