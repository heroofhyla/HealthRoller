# Handles any number of SlotDigit nodes, displaying health Earthbound-style.

extends Node2D

var digits := []
var max_value := 0
var value := 0 setget set_value
var display_value := value
var rng := RandomNumberGenerator.new()

func _ready():
	$Timer.connect("timeout", self, "_timeout")
	for child in $Digits.get_children():
		digits.append(child)
	digits.invert()
	max_value = pow(10, len(digits)) - 1
	$Timer.wait_time = SlotDigit.TIME_PER_DIGIT

func set_value(val: int, instant=false):
	value = val
	if instant:
		for digit in digits:
			digit.roll_direction = 0
			digit.value = val % 10
			val /= 10
	else:
		$Timer.start()
	print(value)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		set_value(rng.randi_range(0,999), false)


func _timeout():
	if value == display_value:
		$Timer.stop()
		return
	var old_display_value = display_value
	display_value += sign(value - display_value)
	var val = display_value
	for digit in digits:
		digit.roll_direction = sign(value - old_display_value)
		digit.value = val % 10
		val /= 10
