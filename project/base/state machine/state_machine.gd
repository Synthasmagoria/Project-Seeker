extends Node

## First state to be pushed to the stack on init
export(String) var default_state
## Stack of states, topmost state (aka. last in the array) is the current state
var state_stack : Array
## Whether or not to continuously process states until one is kept
var continuous_state_processing : bool
# Step function name
var _step_func_name : String

enum ProcessMode{OFF, PROCESS, PHYSICS}

export(ProcessMode) var process_mode = ProcessMode.PROCESS

func init(args : Array = []):
	for n in get_children():
		n.callv("init", args)
	
	assert(!default_state.empty(), "The state machine needs a default state")
	push_by_name(default_state)

func _ready():
	match process_mode:
		ProcessMode.OFF:
			set_process(false)
			set_physics_process(false)
		ProcessMode.PROCESS:
			set_physics_process(false)
		ProcessMode.PHYSICS:
			set_process(false)
	
	if continuous_state_processing:
		_step_func_name = "_step_continuous"
	else:
		_step_func_name = "_step"

func _step_continuous(delta: float) -> void:
	var _new_state = get_current_state().process(delta)
	while !_new_state.empty():
		if _new_state == "_":
			pop()
		else:
			push_by_name(_new_state)
		_new_state = get_current_state().process(delta)

func _step(delta: float) -> void:
	var _new_state = get_current_state().process(delta)
	if _new_state == "_":
		pop()
	elif !_new_state.empty():
		print(_new_state)
		push_by_name(_new_state)

func _process(delta: float) -> void:
	call(_step_func_name, delta)

func _physics_process(delta: float) -> void:
	call(_step_func_name, delta)

# States
func get_current_state() -> Object:
	return state_stack[-1]

func get_state_by_name(val : String) -> Object:
	return get_node_or_null(val)

func get_stack_size() -> int:
	return state_stack.size()

## @desc: Pops current (topmost/last) last state of the stack
func pop():
	get_current_state().exit()
	state_stack.pop_back()
	get_current_state().enter()

## @desc: Pushes a state to the state stack and makes it current
func push(_state : Object):
	if state_stack.size() > 0:
		get_current_state().exit()
	state_stack.append(_state)
	get_current_state().enter()

func push_by_name(val : String):
	var _new_state = get_state_by_name(val)
	if _new_state:
		push(_new_state)
	else:
		printerr(name, ": Couldn't push state by name: ", val)

## @desc: Swaps out the current state
func swap(_state : Object):
	get_current_state().exit()
	state_stack.pop_back()
	state_stack.append(_state)
	get_current_state().enter()

## @desc: Swaps to a state identified by it's node name
func swap_by_name(val : String):
	var _new_state = get_state_by_name(val)
	if _new_state:
		swap(_new_state)
	else:
		printerr(name, ": Couldn't swap to state by name: ", val)

## @desc: Swaps to next state in child order (for test purposes)
func swap_next():
	var _state = get_current_state()
	for i in get_children().size():
		if get_child(i) == _state:
			swap(get_child((i + 1) % get_child_count()))
