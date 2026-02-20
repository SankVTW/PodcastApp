extends Node2D

var bed_music
var podcast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_load_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer2/FileDialog.visible = true
	pass


func _on_file_dialog_file_selected(selected_bed_music_file: String) -> void:
	
	$BedMusicControls/HBoxContainer2/Label.text = selected_bed_music_file
	
	pass # Replace with function body.


func _on_play_bed_music_pressed() -> void:
	
	pass # Replace with function body.
