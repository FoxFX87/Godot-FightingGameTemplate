extends Area

# Test: Area Node used to dictate the time and place to block

func _on_Blockbox_area_entered(hurtbox):
	hurtbox.emit_signal("incomingBlock")
