extends Control

@onready var text_label = $Panel/TextLabel
@onready var timer = $Timer

var full_text := ""
var char_index := 0
var is_typing := false
var queue := []

func show_text(lines: Array):
	if is_typing:
		return
	queue = lines.duplicate()
	_show_next_line()

func _show_next_line():
	if queue.is_empty():
		hide()
		return
	full_text = queue.pop_front()
	text_label.text = ""
	char_index = 0
	is_typing = true
	show()
	timer.start()

func _on_Timer_timeout():
	if char_index < full_text.length():
		text_label.text += full_text[char_index]
		char_index += 1
	else:
		timer.stop()
		is_typing = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			# Instantly complete text
			timer.stop()
			text_label.text = full_text
			is_typing = false
		else:
			_show_next_line()
