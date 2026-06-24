@tool
class_name DemoPortal
extends MeshInstance3D

@export var animation_player: AnimationPlayer

@export_tool_button("Open") var open_action = open
@export_tool_button("Close") var close_action = close

@export_category("Info")
@export_multiline var _description := "Change uniforms below updates both stencil and visual shaders (if applicable) to keep them in sync. See shader for documentation of the parameters."

var _cummulative_time: float = 0.0
var _shader_uniforms: Array = []
var _shader_docs: Dictionary[String, String] = {}
var _apply_material: ShaderMaterial
var _stencil_shader: ShaderMaterial

func _ready() -> void:
	_apply_material = get_surface_override_material(0).next_pass
	_stencil_shader = get_surface_override_material(0)
	_apply_material = _stencil_shader.next_pass
	_shader_uniforms = _apply_material.shader.get_shader_uniform_list()
	_shader_docs = _get_uniform_docs(_apply_material.shader)
	if _apply_material and _stencil_shader:
		for param_dict in _shader_uniforms:
			var param: String = param_dict.name
			if _stencil_shader.get_shader_parameter(param) != _apply_material.get_shader_parameter(param):
				_stencil_shader.set_shader_parameter(param, _apply_material.get_shader_parameter(param))

func _process(_delta: float) -> void:
	if _stencil_shader == null or _apply_material == null:
		_cummulative_time = 0.0
		_stencil_shader = get_surface_override_material(0)
		_apply_material = _stencil_shader.next_pass
		_shader_uniforms = _apply_material.shader.get_shader_uniform_list()
		_shader_docs = _get_uniform_docs(_apply_material.shader)

func _get_property_list():
	var props = []
	for u in _shader_uniforms:
		props.append({
			"name": "Uniforms/" + u.name,
			"type": u.type,
			"usage": PROPERTY_USAGE_DEFAULT,
			"tooltip": _shader_docs.get(u.name, "")
		})
	return props
	
func _get(property):
	if property.begins_with("Uniforms/") and _apply_material:
		var prop_name = property.trim_prefix("Uniforms/")
		return _apply_material.get_shader_parameter(prop_name)
	return null

func _set(property, value):
	if property.begins_with("Uniforms/") and _apply_material and _stencil_shader:
		var prop_name = property.trim_prefix("Uniforms/")
		_apply_material.set_shader_parameter(prop_name, value)
		_stencil_shader.set_shader_parameter(prop_name, value)
		return true

	return false
	
func _get_uniform_docs(shader: Shader) -> Dictionary[String, String]:
	var docs: Dictionary[String, String] = {}
	var code := shader.code
	var regex = RegEx.new()
	regex.compile(r"/\*\*(.*?)\*/\s*uniform\s+\w+\s+(\w+)")
	for m in regex.search_all(code):
		var raw = m.get_string(1)
		var prop_name = m.get_string(2)
		var lines = raw.split("\n")
		for i in range(lines.size()):
			lines[i] = lines[i].strip_edges().trim_prefix("*").strip_edges()
		docs[prop_name] = "\n".join(lines)
	return docs

func open() -> void:
	if animation_player:
		animation_player.play("open", -1, 0.4)

func close() -> void:
	if animation_player:
		animation_player.play("close", -1, 0.4)
