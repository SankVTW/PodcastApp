extends Node2D

var bed_music
var podcast
var bed_volume :float = 0.0
var podcast_volume :float = 0.0
var podcast_playtime : float
var podcast_progress : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#podcast_playtime = 0.0
	print(bed_music)
	print(bed_volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update_bed_music_volume()
	#update_podcast_volume()
	update_podcast_progress()



func load_bed_music_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	print(sound)
	bed_music = sound
	match $BedMusicControls/HBoxContainer/PlayBedMusic.visible:
		true:
			pass
		false:
			$BedMusicControls/HBoxContainer/PlayBedMusic.visible = true
			$BedMusicControls/HBoxContainer/PauseBedMusic.visible = false
func load_podcast_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	print("Podcast is ",   sound.get_length(), " seconds long")
	podcast = sound
	podcast_playtime = podcast.get_length()
	
	$PodcastControls/PodcastPlayerInfo/PodcastProgressBar.max_value = podcast_playtime
	match $PodcastControls/HBoxContainer/PlayPodcast.visible:
		#true:
			#pass
		false:
			$PodcastControls/HBoxContainer/PlayPodcast.visible = true
			$PodcastControls/HBoxContainer/StopPodcast.visible = false

	print(" total play time for" , file , " is ", podcast_playtime/60 , " minutes")
func _on_load_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer2/FileDialog.visible = true
	pass


func _on_file_dialog_file_selected(selected_file: String) -> void:
	
	$BedMusicControls/HBoxContainer2/Label.text = selected_file
	load_bed_music_mp3(selected_file)
	print("bed music" , selected_file)
	
	

func update_bed_music_volume():
	#updates the bed music volume
	_on_pause_bed_music_pressed()
	bed_volume = $BedMusicControls/HScrollBar.value
	$BedMusicControls/BedVolumeLabel.text = str("Volume: ", bed_volume)
	_on_pause_bed_music_pressed()
	
func update_podcast_volume():
	#update the podcast volume
	_on_stop_podcast_pressed()
	podcast_volume = $PodcastControls/PodcastVolumeSlider.value
	$PodcastControls/PodcastVolumeLabel.text = str("Volume: " , podcast_volume)
	_on_stop_podcast_pressed()
func _on_play_bed_music_pressed() -> void:
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream = bed_music
	print(bed_music)
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.volume_db = bed_volume
	print(bed_volume)
	$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing = true
	$BedMusicControls/HBoxContainer/PlayBedMusic.visible = false
	$BedMusicControls/HBoxContainer/PauseBedMusic.visible = true
func _on_pause_bed_music_pressed() -> void:
	if $BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing == true:
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream_paused = true
		$BedMusicControls/HBoxContainer/PauseBedMusic.text = str("Resume")
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.volume_db = bed_volume
	elif $BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.playing == false:
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.stream_paused = false
		$BedMusicControls/HBoxContainer/PlayBedMusic/AudioStreamPlayer.volume_db = bed_volume
		$BedMusicControls/HBoxContainer/PauseBedMusic.text = str("Pause")


func _on_load_podcast_pressed() -> void:
	$PodcastControls/HBoxContainer2/PodcastFileDialog.visible = true
	pass # Replace with function body.


func _on_podcast_file_dialog_file_selected(path: String) -> void:
	$PodcastControls/HBoxContainer2/Label.text = path
	load_podcast_mp3(path)
	print("podcast", path)
	$PodcastControls/HBoxContainer/PlayPodcast.visible = true
	$PodcastControls/HBoxContainer/StopPodcast.visible = false
	_on_stop_podcast_pressed()
	pass # Replace with function body.


func _on_play_podcast_pressed() -> void:
	$PodcastControls/HBoxContainer/AudioStreamPlayer.stream = podcast
	$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress)
	$PodcastControls/HBoxContainer/AudioStreamPlayer.playing = true
	$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
	$PodcastControls/HBoxContainer/PlayPodcast.visible = false
	$PodcastControls/HBoxContainer/StopPodcast.visible = true



func _on_stop_podcast_pressed() -> void:
	if $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == true:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = true
		print (podcast_progress)
		$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
		$PodcastControls/HBoxContainer/StopPodcast.text = str("Resume")
	elif $PodcastControls/HBoxContainer/AudioStreamPlayer.playing == false:
		$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress)
		$PodcastControls/HBoxContainer/AudioStreamPlayer.stream_paused = false
		$PodcastControls/HBoxContainer/AudioStreamPlayer.volume_db = podcast_volume
		$PodcastControls/HBoxContainer/StopPodcast.text = str("Pause")
		

func _on_h_scroll_bar_value_changed(value: float) -> void:
	update_bed_music_volume()
	bed_volume = $BedMusicControls/HScrollBar.value



func _on_podcast_volume_slider_value_changed(value: float) -> void:
	update_podcast_volume()
	podcast_volume = $PodcastControls/PodcastVolumeSlider.value



func update_podcast_progress():
	podcast_progress = $PodcastControls/HBoxContainer/AudioStreamPlayer.get_playback_position()
	$PodcastControls/PodcastPlayerInfo/ProgressArea/ProgressTimeLabel.text = str(roundf(podcast_progress)," / ", podcast_playtime )
	_on_podcast_progress_bar_value_changed(podcast_progress)

func _on_podcast_progress_bar_value_changed(value: float) -> void:
	$PodcastControls/PodcastPlayerInfo/PodcastProgressBar.value = podcast_progress
	

func _on_global_pause_pressed() -> void:
	#pause both audio streams
	_on_stop_podcast_pressed()
	_on_pause_bed_music_pressed()

func _on_global_play_pressed() -> void:
	_on_play_podcast_pressed()
	_on_play_bed_music_pressed()
	$GlobalPauseContainer/GlobalPlay.visible = false
	$GlobalPauseContainer/GlobalPause.visible = true
	pass # Replace with function body.


func _on_forward_30_pressed() -> void:
#seeks forward 30 seconds
	$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress+30)
	update_podcast_progress()
	print(podcast_progress)

func _on_back_15_pressed() -> void:
	#seeks back 15 seconds
	$PodcastControls/HBoxContainer/AudioStreamPlayer.seek(podcast_progress-15)
	update_podcast_progress()
	print(podcast_progress)
	
