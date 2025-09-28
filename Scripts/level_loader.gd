@tool
extends Node2D

@export_tool_button("Save Level", "Save") var save_level_action = save_level
@export var saveAsPlaintext: bool;
@export var level: String = "Temp":
	get: return level;
	set(new):
		level = new;
@export_tool_button("Load Level", "Load") var load_level_action = load_level

@export var start: Vector2 = Vector2(50, 100):
	get: return start;
	set(new):
		start = new;
		$"../Player".position = new;
@export var end: Vector2 = Vector2(950, 900);
@export var bounds: Rect2 = Rect2(0, 0, 1000, 1000);

class LevelData extends Resource:
	@export_storage var movePlatforms: Array[MovePlatformData];
	@export_storage var togglePlatforms: Array[TogglePlatformData];
	@export_storage var start: Vector2;
	@export_storage var end: Vector2;
	@export_storage var bounds: Rect2;
	
class PlatformData extends Resource:
	@export_storage var position: Vector2;
	@export_storage var rotation: float;
	@export_storage var color: int;
	@export_storage var size: Vector2;

class MovePlatformData extends PlatformData:
	@export_storage var positions: Array[Vector2];
	@export_storage var startIndex: int;
	@export_storage var animationDuration: float;
	
class TogglePlatformData extends PlatformData:
	@export_storage var enabled: bool;

func save_level():
	var fp = "res://Levels/" + level.to_lower() + (".tres" if saveAsPlaintext else ".res");
	
	var data: LevelData = LevelData.new();
	data.start = start;
	data.end = end;
	data.bounds = bounds;
	for node in get_children():
		if node is StaticBody2D:
			var nodeData: TogglePlatformData = TogglePlatformData.new();
			nodeData.size = node.size;
			nodeData.position = node.position;
			nodeData.rotation = node.rotation;
			nodeData.color = node.platformColor;
			nodeData.enabled = node.enabled;
		elif node is Node2D and node.has_node("CharacterBody2D"):
			var nodeData: MovePlatformData = MovePlatformData.new();
			nodeData.size = node.size;
			nodeData.position = node.position;
			nodeData.rotation = node.rotation;
			nodeData.color = node.get_node("CharacterBody2D").platformColor;
			nodeData.positions = node.positions;
			nodeData.animationDuration = node.animationDuration;
			nodeData.startIndex = node.startIndex;
			data.movePlatforms.append(nodeData);
		else:
			push_warning("Unknown node: ", node.name, ". Ignoring.");
	
	ResourceSaver.save(data, fp);
	print("saved level to ", fp);

func load_level():
	var fp = "res://Levels/" + level.to_lower() + (".tres" if saveAsPlaintext else ".res");
	if not ResourceLoader.exists(fp):
		push_error("File does not exist: ", fp);
		return;
	
	var data: LevelData = ResourceLoader.load(fp);
	start = data.start;
	end = data.end;
	bounds = data.bounds;
	
	for child in get_children():
		child.queue_free()
		
	var togglePlatformScene = preload("res://Templates/TogglePlatform.tscn");
	var movePlatformScene = preload("res://Templates/MovePlatform.tscn");
	for togglePlatform in data.togglePlatforms:
		var platform = togglePlatformScene.instantiate();
		platform.size = togglePlatform.size;
		platform.position = togglePlatform.position;
		platform.rotation = togglePlatform.rotation;
		platform.platformColor = togglePlatform.color;
		platform.enabled = togglePlatform.enabled;
		add_child(platform);
	
	for movePlatform in data.movePlatforms:
		var platform = movePlatformScene.instantiate();
		platform.size = movePlatform.size;
		platform.position = movePlatform.position;
		platform.rotation = movePlatform.rotation;
		platform.find_child("CharacterBody2D").platformColor = movePlatform.color;
		platform.positions = movePlatform.positions;
		platform.animationDuration = movePlatform.animationDuration;
		platform.startIndex = movePlatform.startIndex;
		add_child(platform);

func _ready() -> void:
	load_level();
