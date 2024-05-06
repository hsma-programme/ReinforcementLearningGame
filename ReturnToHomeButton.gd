extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ConfirmDialog = $ConfirmReturnHomeDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ReturnToHomeButton_button_down():
	ConfirmDialog.popup()
	ConfirmDialog.popup_centered()
	get_tree().paused = true


