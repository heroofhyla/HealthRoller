# Handles a single rolling slot-machine style digit
#
# Use roll_direction to specify how the digit should roll:
#  1: roll up
#  0: set instantly
# -1: roll down

class_name SlotDigit
extends Sprite

const INVERSE_FRAME_RATE := 1.0 / 60.0 
const FRAMES_PER_DIGIT := 4
const TIME_PER_DIGIT = INVERSE_FRAME_RATE * FRAMES_PER_DIGIT
const TOTAL_FRAMES = FRAMES_PER_DIGIT * 10
var value := 0 setget set_value
var target_frame := 0
var unwrapped_frame := 0
var roll_direction = 1
var rng := RandomNumberGenerator.new()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		pass
		#self.value -= rng.randi_range(1,5)

func _ready():
	$Tween.connect("tween_step", self, "_tween_step")


func _tween_step(_object, _key, _elapsed, _value):
	wrap_frame()


func wrap_frame():
	frame = posmod(unwrapped_frame, TOTAL_FRAMES)


func value_to_frame(val: int) -> int:
	return val * FRAMES_PER_DIGIT


func set_value(val: int):
	$Tween.stop_all()
	value = posmod(val,10)
	target_frame = value_to_frame(value)
	
	if target_frame == frame:
		return
	
	if roll_direction == 0:
		frame = target_frame
		return

	if roll_direction > 0:
		while target_frame < frame:
			target_frame += TOTAL_FRAMES

		var frame_delta = target_frame - frame
		var animation_time = abs(frame_delta * INVERSE_FRAME_RATE)
		$Tween.interpolate_property(self, "unwrapped_frame", frame, target_frame, animation_time)
		$Tween.start()
	else:
		while target_frame > frame:
			target_frame -= TOTAL_FRAMES

		var frame_delta = frame - target_frame
		var animation_time = abs(frame_delta * INVERSE_FRAME_RATE)
		$Tween.interpolate_property(self, "unwrapped_frame", frame, target_frame, animation_time)
		$Tween.start()

