extends Node

# base from Kenny altered: https://github.com/KenneyNL/Starter-Kit-3D-Platformer/blob/main/scripts/audio.gd

var num_players = 12
var bus = "master"

var available = []
var queue = []

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)

		available.append(p)

		p.volume_db = -10
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	available.append(stream)

func play(sound_path: String):
	queue.append(sound_path)

func stop(sound_path: String):
	for child in get_children():
		if child is AudioStreamPlayer:
			if child.playing and child.stream:
				var resource_path = child.stream.resource_path

				if resource_path == sound_path:
					child.stop()

					if not available.has(child):
						available.append(child)

func _process(_delta):
	if not queue.is_empty() and not available.is_empty():

		var player = available.pop_front()

		player.stream = load(queue.pop_front())
		player.pitch_scale = randf_range(0.9, 1.1)
		player.play()
