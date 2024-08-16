extends Sprite2D
class_name KKB

var fsm: FSM

static var KKB_SOUND: AudioStream = preload("assets/kkb.ogg")

func _ready() -> void:
	Audio.add_sfx(&"kkb", KKB_SOUND)

	fsm = FSM.setup(self, [
		KkbIdleState,
		KkbSpinningState
	])
