extends Area

export (int) var damage = 1
export (int) var horHit = 0
export (int) var verHit = 0

func _on_Hitbox_area_entered(hurtbox):
	hurtbox.emit_signal("hit", damage, horHit, verHit)
