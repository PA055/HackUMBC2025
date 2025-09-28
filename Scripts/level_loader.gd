@tool
extends Node2D

@export_tool_button("Save Level", "Save") var save_level_action = save_level
@export var saveAsPlaintext: bool;
@export var level: String = "Temp":
	get: return level;
	set(new):
		level = new;
@export_tool_button("Load Level", "Load") var load_level_action = load_level
@export_tool_button("Print Tree", "VisualShaderNodeColorConstant") var print_tree_action = print_tree_pretty;

@export var start: Vector2 = Vector2(50, 100):
	get: return start;
	set(new):
		start = new;
		$"../Player".position = new;
@export var end: Vector2 = Vector2(950, 900);
@export var bounds: Rect2 = Rect2(0, 0, 1000, 1000);

func save_level():
	var fp = "res://Levels/" + level.to_lower() + (".tres" if saveAsPlaintext else ".res")
	
	var data: LevelData = LevelData.new()
	data.start = start
	data.end = end
	data.bounds = bounds
	
	for node in get_children():
		# Toggle platforms
		if "enabled" in node:
			var nodeData: TogglePlatformData = TogglePlatformData.new()
			nodeData.size = node.size
			nodeData.position = node.position
			nodeData.rotation = node.rotation
			nodeData.color = 0
			if node.platformRed: nodeData.color |= 1
			if node.platformYellow: nodeData.color |= 2
			if node.platformBlue: nodeData.color |= 4
			nodeData.enabled = node.enabled
			data.togglePlatforms.append(nodeData)
		
		# Move platforms
		elif "positions" in node:
			var nodeData: MovePlatformData = MovePlatformData.new()
			nodeData.size = node.size
			nodeData.position = node.position
			nodeData.rotation = node.rotation
			nodeData.positions = node.positions
			nodeData.animationDuration = node.animationDuration
			nodeData.startIndex = node.startIndex
			nodeData.color = 0
			if node.platformRed: nodeData.color |= 1
			if node.platformYellow: nodeData.color |= 2
			if node.platformBlue: nodeData.color |= 4
			data.movePlatforms.append(nodeData)
		
		else:
			push_warning("Unknown node: ", node.name, ". Ignoring.")
	
	ResourceSaver.save(data, fp)
	print("Saved level to ", fp)

func load_level():
	var fp = "res://Levels/" + level.to_lower() + (".tres" if saveAsPlaintext else ".res")
	if not ResourceLoader.exists(fp):
		push_error("File does not exist: " + fp)
		return
	
	var data = ResourceLoader.load(fp) as LevelData
	start = data.start
	end = data.end
	bounds = data.bounds
	
	# Clear existing platforms
	for child in get_children():
		child.queue_free()
		
	# Load TogglePlatforms
	var togglePlatformScene = preload("res://Templates/TogglePlatform.tscn")
	for togglePlatform in data.togglePlatforms:
		var platform = togglePlatformScene.instantiate()
		add_child(platform)
		platform.owner = get_tree().edited_scene_root
		
		# Set exported properties (after adding to tree)
		platform.size = togglePlatform.size
		platform.position = togglePlatform.position
		platform.rotation = togglePlatform.rotation
		platform.platformColor = togglePlatform.color
		platform.enabled = togglePlatform.enabled
	
	# Load MovePlatforms
	var movePlatformScene = preload("res://Templates/MovePlatform.tscn")
	for movePlatform in data.movePlatforms:
		var platform = movePlatformScene.instantiate()
		add_child(platform)
		platform.owner = get_tree().edited_scene_root
		
		# Set exported properties through wrappers
		platform.size = movePlatform.size
		platform.position = movePlatform.position
		platform.rotation = movePlatform.rotation
		platform.positions = movePlatform.positions
		platform.animationDuration = movePlatform.animationDuration
		platform.startIndex = movePlatform.startIndex
		
		# Set colors through wrapper
		platform.platformRed = bool(movePlatform.color & 1)
		platform.platformYellow = bool(movePlatform.color & 2)
		platform.platformBlue = bool(movePlatform.color & 4)
		
		# Initialize the platform (updates tracks, NinePatchRect, etc.)
		platform._ready()  # Or platform.initialize() if you prefer

func _ready() -> void:
	load_level();
	pass
