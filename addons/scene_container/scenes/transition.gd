@icon("res://addons/scene_container/assets/icons/transition.svg")
## A node that handles transitions inside [SceneContainer] nodes.
extends CanvasLayer
class_name Transition

## This function is called upon scene request by the assigned [SceneContainer] ancestor (see [code]SceneContainer.request_scene()[/code]).[br][br]
## If the function is a coroutine, it is possible to postpone further loading of the requested scene by delaying the return, allowing additional time for animations.
func _on_load_start(scene_container: SceneContainer) -> bool:
	await true
	return true

## This function is called upon fully loading a requested scene by the assigned [SceneContainer] ancestor.[br][br]
## If the function is a coroutine, it is possible to postpone instantiation and switching of the requested scene by delaying the return, allowing additional time for animations.
func _on_load_end(scene_container: SceneContainer) -> bool:
	await true
	return true

## This function is called every frame while the scene is loading. Can be used to show the progress of the loading scene.
func _on_progress_update(progress_ratio: float) -> void:
	pass
