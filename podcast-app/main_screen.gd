extends Node2D

var bed_music
var podcast
var bed_volume #:float
var podcast_volume #:float
var podcast_playtime
var podcast_progress : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	podcast_playtime = 0.0
	print(bed_music)
	print(bed_volume)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_bed_music_volume()
	update_podcast_volume()
	update_podcast_progress()
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
	print("Podcast is ",   sound.get_length(), " seconds long")
	podcast = sound
	podcast_playtime = podcast.get_length()
	
	$PodcastControls/PodcastPlayerInfo/PodcastProgressBar.max_value = podcast_playtime
	
	#$PodcastControls/PodcastPlayerInfo/ProgressArea/ProgressTimeLabel.text = str(podcast_progress," / ", podcast_playtime )
	print(" total play time for" , file , " is ", podcast_playtime/60 , " minutes")
func _on_load_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer2/FileDialog.visible = true
	pass


func _on_file_dialog_file_selected(selected_file: String) -> void:
	
	$BedMusicControls/HBoxContainer2/Label.text = selected_file
	load_bed_music_mp3(selected_file)
	print("bed music" , selected_file)

	pass # Replace with function body.

func update_bed_music_volume():
	bed_volume = $BedMusicControls/HScrollBar.value
	$BedMusicControls/BedVolumeLabel.text = str("volume: ", bed_volume)
	
func update_podcast_volume():
	podcast_volume = $PodcastControls/PodcastVolumeSlider.value
	$PodcastControls/PodcastVolumeLabel.text = str("volume: " , podcast_volume)
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
	$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress)
	$PodcastControls/HBoxContainer/AudioStreamPlayer.playing = true
	$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
	
	pass # Replace with function body.


func _on_stop_podcast_pressed() -> void:
	if $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == true:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = true
		#podcast_progress = $PodcastControls/HBoxContainer/AudioStreamPlayer.get_playback_position()
		print (podcast_progress)
		$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
	elif $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == false:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress)
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = false
		$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
		
		

func _on_h_scroll_bar_value_changed(value: float) -> void:
	update_bed_music_volume()
	bed_volume = $BedMusicControls/HScrollBar.value
	pass # Replace with function body.


func _on_podcast_volume_slider_value_changed(value: float) -> void:
	update_podcast_volume()
	podcast_volume = $PodcastControls/PodcastVolumeSlider.value
	pass # Replace with function body.


#func _on_loop_bed_music_toggled(toggled_on: bool) -> void:
	#match $BedMusicControls/HBoxContainer/LoopBedMusic.disabled:
		#false : $BedMusicControlsmatch/HBoxContainer/PlayBedMusic/AudioStreamPlayer.looping = true
		#false : print ("looping bed music on")
		#true : $BedMusicControlsmatch/HBoxContainer/PlayBedMusic/AudioStreamPlayer.looping = true
		#true : print ("looping bed music off")
	
	pass # Replace with function body.
func update_podcast_progress():
	podcast_progress = $PodcastControls/HBoxContainer/AudioStreamPlayer.get_playback_position()
	$PodcastControls/PodcastPlayerInfo/ProgressArea/ProgressTimeLabel.text = str(roundf(podcast_progress)," / ", podcast_playtime )
	_on_podcast_progress_bar_value_changed(podcast_progress)
	#print(roundf(podcast_progress)," / ", podcast_playtime )
	
	


func _on_podcast_progress_bar_value_changed(value: float) -> void:
	$PodcastControls/PodcastPlayerInfo/PodcastProgressBar.value = podcast_progress
	
	pass # Replace with function body.
