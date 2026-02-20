extends FileDialog

var selected_file : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".file_mode = FileDialog.FILE_MODE_OPEN_DIR 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	file_selected.emit(selected_file)
	pass
