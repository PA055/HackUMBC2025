@tool
extends Line2D

var colors: Array[Color] = [
	Color("#FCFFE9"),
	Color("#FF1F00"),
	Color("#FFD700"),
	Color("#FF6900"),
	Color("#0000CD"),
	Color("#800080"),
	Color("#00A400"),
	Color("#2D343A")
]

@export_tool_button("Load Path", "Path2D")
var load_path_action = load_path;

func load_path():
	points = [];
	var fp = "res://Debug/path.txt"
	if not FileAccess.file_exists(fp):
		push_error("File does not exist: ", fp);
		return;
	
	for child in get_children():
		child.queue_free()
	
	var v = Vector2.ZERO;
	var file = FileAccess.open(fp, FileAccess.READ);
	while not file.eof_reached():
		var line = file.get_line()
		if line.begins_with("key: "):
			line = line.lstrip("key: ")
			var keyColor = colors[line.to_int()];
			var icon = Sprite2D.new()
			icon.texture = preload("res://Assets/Testing/circle.png");
			icon.modulate = keyColor;
			icon.global_position = v;
			icon.scale = Vector2(1.0 / 16.0, 1.0 / 16.0);
			add_child(icon);
			continue;
		line = line.lstrip("(").rstrip(")");
		var parts = line.split(",")
		if parts.size() < 2: continue;
		v = Vector2(parts[0].to_float(), parts[1].to_float())
		add_point(v);

func _ready() -> void:
	if not Engine.is_editor_hint():
		visible = false;
