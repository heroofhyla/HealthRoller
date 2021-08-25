extends Label

var real_health: int = 500
var display_health: int = 500
var rng = RandomNumberGenerator.new()
 

func _ready():
	rng.randomize()
	update_text()


# I'm using a text label to show the display health. Call an AnimationPlayer or
# something here instead if you have animations for each number changing.
func update_text():
	text = "%03d" % display_health


# When the timer runs out, step the display health by 1 towards the actual
# health.
func _on_Timer_timeout():
	if display_health != real_health:
		display_health += sign(real_health - display_health)
		update_text()


func function_that_might_yield():
	if rng.randf() < 0.5:
		print("waiting for 1 second")
		yield(get_tree().create_timer(1.0),"timeout")
	else:
		print("no timeout")
	print("function done!")
	return true

# For debug, setting HP to a random value each time I hit space.
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var maybe_yield = function_that_might_yield()
		if maybe_yield is GDScriptFunctionState:
			yield(maybe_yield, "completed")
		print("ping")
		real_health = rng.randi_range(0,999)
