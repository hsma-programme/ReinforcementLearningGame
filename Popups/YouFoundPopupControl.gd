extends Control


func _on_DismissAutoTimer_timeout():
	get_tree().paused = false
