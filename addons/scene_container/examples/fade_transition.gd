extends Transition

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_load_end(scene_container: SceneContainer) -> bool:
	animation_player.play("fadein")
	
	while animation_player.is_playing():
		await get_tree().process_frame
	
	animation_player.play("fadeout")
	
	return true
