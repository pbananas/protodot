extends Node2D
class_name ExpirableParticles

func expire() -> void:
	var max_lifetime: float = 0
	for particles in get_children():
		if particles is not GPUParticles2D: continue
		if particles.lifetime > max_lifetime:
			max_lifetime = particles.lifetime
		particles.emitting = false

	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
