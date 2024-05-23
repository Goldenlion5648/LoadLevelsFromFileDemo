extends TileMap

const FILLER = "."
var letter_to_atlas_coord = {
	"R": Vector2i(0,0),
	"G": Vector2i(3,0),
	"B": Vector2i(1,0),
	"H": Vector2i(3,1),
}

const main_layer = 0
const main_source_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_file("res://levels/level1.txt")


func load_level_file(path: String):
	var contents = FileAccess.open(path, FileAccess.READ).get_as_text()
	var sections = contents.split("\n\n", false)
	var level_contents = sections[0]
	place_tiles_based_on_string(level_contents)
	if len(sections) > 1:
		var settings = sections[1]
		read_settings(settings)

func place_tiles_based_on_string(level_contents: String):
	var board = level_contents.strip_edges().split("\n", false) as Array
	board = board.map(func(line: String): return line.strip_edges().split(" ", false))
	for y in range(len(board)):
		for x in range(len(board[y])):
			if board[y][x] == FILLER:
				continue
			for i in range(len(board[y][x])):
				set_cell(i, Vector2i(x, y), main_source_id, letter_to_atlas_coord[board[y][x][i]])


func read_settings(settings: String):
	for setting in settings.split("\n", false):
		var setting_name_and_value = setting.split("=")
		var setting_name = setting_name_and_value[0].strip_edges()
		var setting_value = setting_name_and_value[1]
		if setting_name == "zoom":
			var camera = get_node("main_camera") as Camera2D
			camera.zoom.x = float(setting_value)
			camera.zoom.y = float(setting_value)
