extends Node


signal cheatmode(data)

var _pending_data = null
var _pending_signal = false

func emit_when_ready(data):
	_pending_data = data
	await get_tree().create_timer(0.1).timeout
	cheatmode.emit(_pending_data)
	_pending_data = null
"""
Syfte: Skicka ut en signal level och wave_manager
Kommentar: Level och wave_manager finns inte då funtionen körs så därför behöver man
           vänta ish 0,1 sekuner
"""
