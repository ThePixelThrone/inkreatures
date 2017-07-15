extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const BLINK_INTERVAL = 0.5
const BLINK_CYCLE = 0.9
var blink = 0.0

func _ready():
	set_process(true)
	
func _process(delta):
	blink += delta
	if (blink > BLINK_INTERVAL):
		self.hide()
		if (blink > BLINK_CYCLE):
			self.show()
			blink = 0
	
