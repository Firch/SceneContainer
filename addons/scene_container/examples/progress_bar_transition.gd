extends Transition

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_progress: Label = $ColorRect/LabelProgress

func _on_load_start(scene_container: SceneContainer) -> bool:
	animation_player.play("fadein")
	
	return true

func _on_load_end(scene_container: SceneContainer) -> bool:
	
	while animation_player.is_playing():
		await get_tree().process_frame
	
	animation_player.play("fadeout")
	
	return true

func _on_progress_update(progress_ratio: float) -> void:
	label_progress.set_text(str(progress_ratio * 100) + "%")
