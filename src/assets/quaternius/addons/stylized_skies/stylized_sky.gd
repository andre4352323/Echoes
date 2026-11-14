class_name StylizedSky
extends RefCounted
## Helpers for the Stylized Skies presets (REEBOO Labs).
##
## A preset is a ShaderMaterial using stylized_sky.gdshader. Its metadata holds the matching
## light colour / energy, ambient energy, fog colour and the direction the main light comes from.
##
##   StylizedSky.apply(load("res://addons/stylized_skies/presets/sunset_golden_hour.tres"), $WorldEnvironment.environment, $Sun)

const PRESET_DIR := "res://addons/stylized_skies/presets/"
const SHADER_PATH := "res://addons/stylized_skies/shaders/stylized_sky.gdshader"


## Puts the preset on the environment's sky (creating the Sky if needed) and, if given,
## points and colours the light like the preset (sun by day, moon by night).
static func apply(preset: ShaderMaterial, env: Environment, light: DirectionalLight3D = null, set_fog := true) -> void:
	if env == null or preset == null:
		return
	if env.sky == null:
		env.sky = Sky.new()
	env.background_mode = Environment.BG_SKY
	env.sky.sky_material = preset
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	env.ambient_light_energy = float(preset.get_meta("ambient_energy", 1.0))
	if set_fog:
		env.fog_light_color = preset.get_meta("fog_color", Color(0.8, 0.85, 0.95))
	if light:
		orient_light(light, light_direction(preset))
		light.light_color = preset.get_meta("light_color", Color.WHITE)
		light.light_energy = float(preset.get_meta("light_energy", 1.0))


## Direction the main light comes from (towards the sun or moon), from the preset metadata.
static func light_direction(preset: ShaderMaterial) -> Vector3:
	var d = preset.get_meta("light_direction", null)
	if d == null:
		d = get_param(preset, "sun_direction")
	return (d as Vector3).normalized()


## Turns a DirectionalLight3D so that its light comes from `from_dir` (a direction towards the light).
static func orient_light(light: DirectionalLight3D, from_dir: Vector3) -> void:
	var d := from_dir.normalized()
	var up := Vector3.UP if absf(d.y) < 0.99 else Vector3.FORWARD
	var b := Basis.looking_at(-d, up)
	if light.is_inside_tree():
		light.global_basis = b
	else:
		light.basis = b


## Value of a shader parameter, falling back to the shader default.
static func get_param(mat: ShaderMaterial, param: StringName) -> Variant:
	var v = mat.get_shader_parameter(param)
	if v == null and mat.shader:
		v = RenderingServer.shader_get_parameter_default(mat.shader.get_rid(), param)
	return v


## Writes a blend of two presets into `target` (t = 0 gives a, 1 gives b). Skips names in `skip`.
static func blend(target: ShaderMaterial, a: ShaderMaterial, b: ShaderMaterial, t: float, skip: Array = []) -> void:
	for u in a.shader.get_shader_uniform_list():
		var n: StringName = u["name"]
		if n in skip:
			continue
		var va = get_param(a, n)
		var vb = get_param(b, n)
		if va == null or vb == null:
			continue
		target.set_shader_parameter(n, mix_values(va, vb, t))


## Linear blend for floats, colours and vectors; other types switch at the middle.
static func mix_values(a: Variant, b: Variant, t: float) -> Variant:
	match typeof(a):
		TYPE_FLOAT, TYPE_INT:
			return lerpf(float(a), float(b), t)
		TYPE_COLOR:
			return (a as Color).lerp(b, t)
		TYPE_VECTOR2:
			return (a as Vector2).lerp(b, t)
		TYPE_VECTOR3:
			return (a as Vector3).lerp(b, t)
		TYPE_VECTOR4:
			return (a as Vector4).lerp(b, t)
	return a if t < 0.5 else b


## Loads every preset listed in sky_catalog.json (falls back to scanning the folder).
static func list_presets() -> Array[String]:
	var out: Array[String] = []
	var cat := PRESET_DIR.get_base_dir().get_base_dir() + "/sky_catalog.json"
	if FileAccess.file_exists(cat):
		var data = JSON.parse_string(FileAccess.get_file_as_string(cat))
		if data is Dictionary:
			for c in data.get("categories", []):
				for s in c.get("skies", []):
					out.append(PRESET_DIR + String(s["slug"]) + ".tres")
	if out.is_empty():
		for f in DirAccess.get_files_at(PRESET_DIR):
			f = f.trim_suffix(".remap")
			if f.ends_with(".tres"):
				out.append(PRESET_DIR + f)
	return out
