extends Node2D

var bed_music
var podcast
var bed_volume 
var podcast_volume


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print(bed_music)
	print(bed_volume)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bed_volume = $BedMusicControls/HScrollBar.value
	print("be music volume", bed_volume)
	pass


func load_bed_music_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	print(sound)
	bed_music = sound
	
func load_podcast_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	print(sound)
	podcast = sound
func _on_load_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer2/FileDialog.visible = true
	pass


func _on_file_dialog_file_selected(selected_file: String) -> void:
	
	$BedMusicControls/HBoxContainer2/Label.text = selected_file
	load_bed_music_mp3(selected_file)
	print("bed music" , selected_file)
	
	pass # Replace with function body.


func _on_play_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream = bed_music
	print(bed_music)
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.volume_db = bed_volume
	print(bed_volume)
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing = true

func _on_pause_bed_music_pressed() -> void:
	if $BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing == true:
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream_paused = true
	elif $BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing == false:
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream_paused = false
	
	pass # Replace with function body.


func _on_load_podcast_pressed() -> void:
	$PodcastControls/HBoxContainer2/PodcastFileDialog.visible = true
	pass # Replace with function body.


func _on_podcast_file_dialog_file_selected(path: String) -> void:
	$PodcastControls/HBoxContainer2/Label.text = path
	load_podcast_mp3(path)
	print("podcast", path)
	pass # Replace with function body.


func _on_play_podcast_pressed() -> void:
	$PodcastControls/HBoxContainer/AudioStreamPlayer.stream = podcast
	$PodcastControls/HBoxContainer/AudioStreamPlayer.playing = true
	$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = 5.0
	
	pass # Replace with function body.


func _on_stop_podcast_pressed() -> void:
	if $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == true:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = true
	elif $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == false:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = false


func _on_h_scroll_bar_value_changed(value: float) -> void:
	bed_volume = $BedMusicControls/HScrollBar.value
	pass # Replace with function body.
