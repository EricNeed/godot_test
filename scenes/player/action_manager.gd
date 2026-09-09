extends AnimationTree

enum ActionPart{
	NONE,
	FULLBODY,
	UPPERBODY,
}
enum Actions{
	NONE,
	IDEL,
	WALKING,
}
var actions_info: Array[Array] = [] #[[priority, anim name in mesh, effect part],[...]]
func _ready() -> void:
	actions_info.resize(Actions.size())
	#small function that add action to a array
	var _action_info = func(act_enum, priority, anim_name, effect_part): actions_info[act_enum] = [priority, anim_name, effect_part]
	_action_info.call(Actions.NONE, 0, "", ActionPart.NONE)
	_action_info.call(Actions.IDEL, 0, "Idel", ActionPart.FULLBODY)
	_action_info.call(Actions.WALKING, 0, "walking_v2", ActionPart.FULLBODY)


## current state of animation
var _anim_body := Actions.IDEL
var _anim_upper := Actions.NONE


func _play_animation(new_action: Actions):
	var action_info = actions_info[new_action]
	
	var is_upper_body := "AnimFullBody" if action_info[2] == ActionPart.FULLBODY else "AnimUpperBody"
	var state_machine := $".".get("parameters/" + is_upper_body + "/playback") as AnimationNodeStateMachinePlayback
	state_machine.travel(action_info[1])
	
	#blend2 that mix upper body with lower movement animation
	var blend_factor := 1 if actions_info[_anim_upper][0] > actions_info[_anim_body][0] else 0
	$".".set("parameters/Blend2/blend_amount", blend_factor)


func start_walking():
	_anim_body = Actions.WALKING
	_play_animation(Actions.WALKING)
func stop_walking():
	_anim_body = Actions.IDEL
	_play_animation(Actions.IDEL)


### [return] true if success, false if not
#func add_action(action: Actions) -> bool:
	#return true
#
### [return] true if success, false if not
#func stop_action(action: Actions) -> bool:
	#return true	
	
## Called when the node enters the scene tree for the first time.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
