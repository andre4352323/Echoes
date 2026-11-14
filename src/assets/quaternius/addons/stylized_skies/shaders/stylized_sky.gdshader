// Stylized Skies - live sky shader for Godot 4.4+ (REEBOO Labs)
// Sun, moon, stars, milky way, aurora, planet, cirrus and toon-shaded cumulus clouds,
// all procedural. Works on Forward+, Mobile and Compatibility.
// Tip: turn on Project Settings > Rendering > Anti Aliasing > Use Debanding for smooth gradients.
// Put it on a ShaderMaterial in Sky > sky_material, or load one of the presets.
shader_type sky;

#include "res://addons/stylized_skies/shaders/stylized_sky.gdshaderinc"

group_uniforms scene_lights;
// When on, the sun / moon follow the first / second DirectionalLight3D in the scene.
uniform bool sun_from_light0 = false;
uniform bool moon_from_light1 = false;

group_uniforms animation;
uniform float time_scale : hint_range(0.0, 20.0) = 1.0;
uniform float time_offset = 0.0;
// Fewer octaves are used for the reflection / ambient cubemap (cheaper, looks the same there).
uniform float cubemap_detail : hint_range(1.0, 8.0, 1.0) = 3.0;
group_uniforms;

void sky() {
	vec3 sd = sun_direction;
	if (sun_from_light0 && LIGHT0_ENABLED) {
		sd = LIGHT0_DIRECTION;
	}
	vec3 md = moon_direction;
	if (moon_from_light1 && LIGHT1_ENABLED) {
		md = LIGHT1_DIRECTION;
	}
	float t = TIME * time_scale + time_offset;
	float oct = AT_CUBEMAP_PASS ? min(cubemap_detail, cloud_detail) : cloud_detail;
	vec3 c = stylized_sky(EYEDIR, sd, md, t, oct);
	COLOR = max(c, vec3(0.0));
}
