extends AudioStreamPlayer

var music_stream : AudioStream = preload("res://Assets/Music/3-02 Kokiri Forest (Hyrule Symphony).mp3")  # Your default background music

func _ready():
	if not playing:
		stream = music_stream
		music_stream.loop = true  # Enable looping directly on the AudioStream
		play()

func pause_music():
	if playing:
		stop()

func resume_music():
	if not playing:
		play()

func set_volume(volume_db: float):
	self.volume_db = volume_db  # Properly sets the volume

func set_music(new_music: AudioStream):
	if music_stream != new_music:  # Ensure we're not resetting the music to the same one
		music_stream = new_music
		music_stream.loop = true  # Enable looping for the new music
		stream = music_stream
		if not playing:
			play()
