extends Node2D
class_name AutoExpiringParticles

func _ready() -> void:
	var max_lifetime: float = 0

	var particles: Array
	if self.is_class("CPUParticles2D") or self.is_class("GPUParticles2D"):
		particles = [self]
	else:
		particles = get_children()

	for emitter in particles:
		if not (emitter is GPUParticles2D or emitter is CPUParticles2D): continue
		if emitter.lifetime > max_lifetime:
			max_lifetime = emitter.lifetime
		emitter.emitting = true

	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
