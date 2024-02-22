extends Node2D

signal explosion_done()

func _on_area_entered(area):
  if area.is_in_group("unbreakable"):
    return
  area.queue_free()


func _on_animation_player_animation_finished(_anim_name: String):
  explosion_done.emit()
  queue_free()
