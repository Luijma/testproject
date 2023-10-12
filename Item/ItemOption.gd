extends Control


signal option_selected(button_selected: Button)
@onready var button: Button = $Button


func _on_button_pressed():
	print("option selected: " + button.text)
	option_selected.emit(button)

func set_item_option_info(option_text: String):
	button.text = option_text
