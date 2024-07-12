extends Node3D

func _input(event):
	if event.is_action_type():
		if event.is_action_pressed("pause"):
			if get_tree().paused:
				print("Unpaused")
				get_tree().paused = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				get_tree().paused = true
				print("Paused")
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
