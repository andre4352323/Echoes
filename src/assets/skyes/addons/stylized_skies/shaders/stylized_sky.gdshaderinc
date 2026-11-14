// Stylized Skies - shared sky function (REEBOO Labs).
// Included by stylized_sky.gdshader (the live sky). All colours are entered in sRGB
// and used in linear space. The function returns a linear colour for EYEDIR.

#ifndef SKY_COLOR
#define SKY_COLOR : source_color
#endif

group_uniforms gradient;
uniform vec4 zenith_color SKY_COLOR = vec4(0.16, 0.38, 0.80, 1.0);
uniform vec4 sky_color SKY_COLOR = vec4(0.36, 0.62, 0.95, 1.0);
uniform vec4 horizon_color SKY_COLOR = vec4(0.80, 0.90, 1.00, 1.0);
uniform vec4 ground_color SKY_COLOR = vec4(0.34, 0.38, 0.44, 1.0);
uniform float horizon_offset : hint_range(-0.3, 0.3) = 0.0;
uniform float horizon_width : hint_range(0.01, 1.0) = 0.22;
uniform float zenith_height : hint_range(0.05, 1.0) = 0.65;
uniform float ground_blend : hint_range(0.001, 0.6) = 0.08;

group_uniforms sun;
uniform vec3 sun_direction = vec3(0.0, 0.35, -1.0);
uniform vec4 sun_color SKY_COLOR = vec4(1.0, 0.96, 0.86, 1.0);
uniform float sun_size : hint_range(0.0, 30.0) = 3.0;
uniform float sun_edge : hint_range(0.0, 1.0) = 0.15;
uniform float sun_intensity : hint_range(0.0, 8.0) = 1.6;
uniform vec4 sun_glow_color SKY_COLOR = vec4(1.0, 0.85, 0.6, 1.0);
uniform float sun_glow_intensity : hint_range(0.0, 4.0) = 0.45;
uniform float sun_glow_size : hint_range(0.01, 1.5) = 0.3;
uniform float horizon_glow : hint_range(0.0, 4.0) = 0.3;
uniform float horizon_glow_spread : hint_range(0.0, 1.0) = 0.5;

group_uniforms moon;
uniform vec3 moon_direction = vec3(0.5, 0.45, 0.75);
uniform vec4 moon_color SKY_COLOR = vec4(0.95, 0.96, 1.0, 1.0);
uniform float moon_size : hint_range(0.0, 40.0) = 0.0;
uniform float moon_phase : hint_range(-1.0, 1.0) = 0.0;
uniform float moon_intensity : hint_range(0.0, 4.0) = 1.0;
uniform float moon_craters : hint_range(0.0, 1.0) = 0.5;
uniform float moon_dark_side : hint_range(0.0, 1.0) = 0.9;
uniform vec4 moon_glow_color SKY_COLOR = vec4(0.6, 0.7, 1.0, 1.0);
uniform float moon_glow : hint_range(0.0, 3.0) = 0.3;

group_uniforms stars;
uniform float star_intensity : hint_range(0.0, 4.0) = 0.0;
uniform float star_density : hint_range(0.0, 1.0) = 0.5;
uniform float star_size : hint_range(0.2, 3.0) = 1.0;
uniform float star_twinkle : hint_range(0.0, 1.0) = 0.3;
uniform vec4 star_color SKY_COLOR = vec4(1.0, 1.0, 1.0, 1.0);
uniform float star_color_variation : hint_range(0.0, 1.0) = 0.4;
uniform float star_horizon_fade : hint_range(0.0, 1.0) = 0.25;
uniform float milky_way_intensity : hint_range(0.0, 4.0) = 0.0;
uniform vec4 milky_way_color_a SKY_COLOR = vec4(0.45, 0.55, 0.95, 1.0);
uniform vec4 milky_way_color_b SKY_COLOR = vec4(0.95, 0.55, 0.80, 1.0);
uniform vec3 milky_way_axis = vec3(0.35, 0.55, 0.75);
uniform float milky_way_width : hint_range(0.05, 3.0) = 0.25;

group_uniforms clouds;
uniform float cloud_coverage : hint_range(0.0, 1.0) = 0.45;
uniform float cloud_softness : hint_range(0.001, 0.5) = 0.06;
uniform float cloud_scale : hint_range(0.05, 4.0) = 1.0;
uniform float cloud_stretch : hint_range(0.25, 4.0) = 1.0;
uniform float cloud_curvature : hint_range(0.02, 1.0) = 0.18;
uniform float cloud_warp : hint_range(0.0, 2.0) = 0.6;
uniform float cloud_billow : hint_range(0.0, 1.0) = 0.5;
uniform float cloud_detail : hint_range(1.0, 8.0, 1.0) = 6.0;
uniform vec2 cloud_wind = vec2(0.010, 0.004);
uniform float cloud_seed : hint_range(0.0, 100.0) = 0.0;
uniform vec4 cloud_light_color SKY_COLOR = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 cloud_shadow_color SKY_COLOR = vec4(0.62, 0.70, 0.84, 1.0);
uniform vec4 cloud_rim_color SKY_COLOR = vec4(1.0, 0.95, 0.85, 1.0);
uniform float cloud_rim : hint_range(0.0, 3.0) = 0.6;
uniform float cloud_shading : hint_range(0.0, 4.0) = 1.0;
uniform float cloud_thickness : hint_range(0.0, 1.0) = 0.2;
uniform float cloud_steps : hint_range(0.0, 8.0, 1.0) = 3.0;
uniform float cloud_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float cloud_horizon_fade : hint_range(0.0, 0.5) = 0.05;

group_uniforms cumulus;
uniform float cumulus_coverage : hint_range(0.0, 1.0) = 0.0;
uniform float cumulus_scale : hint_range(0.2, 4.0) = 1.0;
uniform float cumulus_seed : hint_range(0.0, 100.0) = 0.0;

group_uniforms cloud_bank;
uniform float bank_coverage : hint_range(0.0, 1.0) = 0.0;
uniform float bank_height : hint_range(0.2, 3.0) = 1.0;
uniform float bank_count : hint_range(8.0, 80.0, 1.0) = 26.0;
uniform float bank_base : hint_range(-0.1, 0.3) = 0.0;
uniform float bank_haze : hint_range(0.0, 1.0) = 0.3;
uniform float bank_seed : hint_range(0.0, 100.0) = 0.0;

group_uniforms cirrus;
uniform float cirrus_coverage : hint_range(0.0, 1.0) = 0.0;
uniform vec4 cirrus_color SKY_COLOR = vec4(1.0, 1.0, 1.0, 1.0);
uniform float cirrus_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float cirrus_scale : hint_range(0.05, 4.0) = 0.8;
uniform float cirrus_stretch : hint_range(1.0, 10.0) = 3.0;
uniform float cirrus_angle : hint_range(-3.1416, 3.1416) = 0.4;

group_uniforms aurora;
uniform float aurora_intensity : hint_range(0.0, 4.0) = 0.0;
uniform vec4 aurora_color_a SKY_COLOR = vec4(0.2, 1.0, 0.6, 1.0);
uniform vec4 aurora_color_b SKY_COLOR = vec4(0.6, 0.3, 1.0, 1.0);
uniform float aurora_scale : hint_range(0.1, 4.0) = 1.0;
uniform float aurora_speed : hint_range(0.0, 2.0) = 0.3;

group_uniforms planet;
uniform float planet_intensity : hint_range(0.0, 2.0) = 0.0;
uniform vec3 planet_direction = vec3(-0.6, 0.4, -0.7);
uniform float planet_size : hint_range(1.0, 60.0) = 18.0;
uniform vec4 planet_color_a SKY_COLOR = vec4(0.9, 0.7, 0.5, 1.0);
uniform vec4 planet_color_b SKY_COLOR = vec4(0.6, 0.4, 0.4, 1.0);
uniform float planet_bands : hint_range(0.0, 1.0) = 0.6;
uniform vec4 planet_atmosphere_color SKY_COLOR = vec4(0.7, 0.8, 1.0, 1.0);
uniform float planet_emission : hint_range(0.0, 1.0) = 0.0;
uniform float planet_ring : hint_range(0.0, 1.0) = 0.0;
uniform vec4 planet_ring_color SKY_COLOR = vec4(0.9, 0.85, 0.75, 1.0);
uniform float planet_ring_tilt : hint_range(0.05, 1.0) = 0.25;
uniform float planet_ring_angle : hint_range(-3.1416, 3.1416) = 0.3;

group_uniforms atmosphere;
uniform vec4 haze_color SKY_COLOR = vec4(0.85, 0.9, 1.0, 1.0);
uniform float haze_amount : hint_range(0.0, 1.0) = 0.25;
uniform float haze_height : hint_range(0.005, 0.5) = 0.06;
uniform float lightning_flash : hint_range(0.0, 1.0) = 0.0;
uniform float exposure : hint_range(0.0, 4.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
group_uniforms;

// ------------------------------------------------------------------ helpers
vec3 sky_lin(vec4 c) {
#ifdef SKY_BAKE
	vec3 x = c.rgb;
	return mix(x / 12.92, pow((x + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), x));
#else
	return c.rgb;
#endif
}

// sky_hash12, sky_hash22, sky_hash33, sky_hash13: "Hash without Sine" by David Hoskins,
// Copyright (c) 2014 David Hoskins, MIT License (https://www.shadertoy.com/view/4djSRW).
// Full notice: LICENSE.txt, section THIRD-PARTY CODE.

float sky_hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

vec2 sky_hash22(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx + p3.yz) * p3.zy);
}

vec3 sky_hash33(vec3 p3) {
	p3 = fract(p3 * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return fract((p3.xxy + p3.yxx) * p3.zyx);
}

float sky_hash13(vec3 p3) {
	p3 = fract(p3 * 0.1031);
	p3 += dot(p3, p3.zyx + 31.32);
	return fract((p3.x + p3.y) * p3.z);
}

float sky_gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	vec2 ga = sky_hash22(i) * 2.0 - 1.0;
	vec2 gb = sky_hash22(i + vec2(1.0, 0.0)) * 2.0 - 1.0;
	vec2 gc = sky_hash22(i + vec2(0.0, 1.0)) * 2.0 - 1.0;
	vec2 gd = sky_hash22(i + vec2(1.0, 1.0)) * 2.0 - 1.0;
	float va = dot(ga, f);
	float vb = dot(gb, f - vec2(1.0, 0.0));
	float vc = dot(gc, f - vec2(0.0, 1.0));
	float vd = dot(gd, f - vec2(1.0, 1.0));
	return mix(mix(va, vb, u.x), mix(vc, vd, u.x), u.y);
}

float sky_billow(vec2 p, float octaves, float lod) {
	float s = 0.0;
	float a = 0.5;
	float norm = 0.0;
	float keep = octaves - lod * 3.0;
	for (int i = 0; i < 8; i++) {
		float fi = float(i);
		if (fi >= octaves) {
			break;
		}
		float w = fi == 0.0 ? 1.0 : clamp(keep - fi + 1.0, 0.0, 1.0);
		s += a * w * (1.0 - abs(sky_gnoise(p)) * 2.0);
		norm += a;
		p = mat2(vec2(0.8, -0.6), vec2(0.6, 0.8)) * p * 2.07 + vec2(11.3, 5.9);
		a *= 0.5;
	}
	return 0.5 + 0.5 * s / norm;
}

// fbm in 0..1; lod fades out the finest octaves (0 = all octaves, 1 = fewer)
float sky_fbm(vec2 p, float octaves, float lod) {
	float s = 0.0;
	float a = 0.5;
	float norm = 0.0;
	float keep = octaves - lod * 3.0;
	for (int i = 0; i < 8; i++) {
		float fi = float(i);
		if (fi >= octaves) {
			break;
		}
		float w = clamp(keep - fi + 1.0, 0.0, 1.0);
		if (fi == 0.0) {
			w = 1.0;
		}
		s += a * w * sky_gnoise(p);
		norm += a;
		p = mat2(vec2(0.8, -0.6), vec2(0.6, 0.8)) * p * 2.03 + vec2(17.1, 3.7);
		a *= 0.5;
	}
	return 0.5 + s / norm * 0.95;
}

float sky_vnoise3(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float n000 = sky_hash13(i);
	float n100 = sky_hash13(i + vec3(1.0, 0.0, 0.0));
	float n010 = sky_hash13(i + vec3(0.0, 1.0, 0.0));
	float n110 = sky_hash13(i + vec3(1.0, 1.0, 0.0));
	float n001 = sky_hash13(i + vec3(0.0, 0.0, 1.0));
	float n101 = sky_hash13(i + vec3(1.0, 0.0, 1.0));
	float n011 = sky_hash13(i + vec3(0.0, 1.0, 1.0));
	float n111 = sky_hash13(i + vec3(1.0, 1.0, 1.0));
	return mix(mix(mix(n000, n100, f.x), mix(n010, n110, f.x), f.y),
			mix(mix(n001, n101, f.x), mix(n011, n111, f.x), f.y), f.z);
}

float sky_fbm3(vec3 p, int octaves) {
	float s = 0.0;
	float a = 0.5;
	float norm = 0.0;
	for (int i = 0; i < 6; i++) {
		if (i >= octaves) {
			break;
		}
		s += a * sky_vnoise3(p);
		norm += a;
		p = p * 2.07 + vec3(5.3, 1.7, 9.1);
		a *= 0.5;
	}
	return s / norm;
}

void sky_basis(vec3 n, out vec3 t, out vec3 b) {
	vec3 up = abs(n.y) < 0.95 ? vec3(0.0, 1.0, 0.0) : vec3(1.0, 0.0, 0.0);
	t = normalize(cross(up, n));
	b = cross(n, t);
}

float sky_toon(float x, float steps) {
	if (steps < 0.5) {
		return x;
	}
	float v = x * steps;
	float i = floor(v);
	float f = smoothstep(0.38, 0.62, fract(v));
	return clamp((i + f) / steps, 0.0, 1.0);
}

// --------------------------------------------------------------- layers
vec3 sky_stars(vec3 dir, float t, float band) {
	vec3 acc = vec3(0.0);
	float dens = clamp(star_density + band * 0.35, 0.0, 1.0);
	for (int layer = 0; layer < 3; layer++) {
		float fl = float(layer);
		float scale = fl == 0.0 ? 70.0 : (fl == 1.0 ? 140.0 : 260.0);
		vec3 p = dir * scale;
		vec3 cell = floor(p);
		vec3 h = sky_hash33(cell + fl * 31.7);
		float present = step(1.0 - dens * (fl == 0.0 ? 0.12 : (fl == 1.0 ? 0.3 : 0.6)), sky_hash13(cell * 1.37 + 11.0 + fl));
		if (present > 0.0) {
			vec3 c = cell + 0.3 + 0.4 * h;
			float d = length(p - c);
			float rad = star_size * (fl == 0.0 ? 0.075 : (fl == 1.0 ? 0.085 : 0.11)) * (0.6 + 0.8 * h.z);
			float core = exp(-d * d / (rad * rad));
			float bright = (fl == 0.0 ? 2.2 : (fl == 1.0 ? 1.2 : 0.6)) * (0.35 + 0.65 * h.x * h.x);
			float tw = 1.0 - star_twinkle * (0.5 + 0.5 * sin(t * (2.0 + 3.0 * h.y) + h.z * 40.0));
			float k = h.y;
			vec3 tint = k < 0.33 ? vec3(0.75, 0.85, 1.0) : (k < 0.66 ? vec3(1.0) : vec3(1.0, 0.85, 0.65));
			tint = mix(vec3(1.0), tint, star_color_variation);
			acc += core * bright * tw * tint;
		}
	}
	return acc * sky_lin(star_color);
}

vec3 sky_milky_way(vec3 dir, out float band) {
	vec3 ax = normalize(milky_way_axis);
	float d = dot(dir, ax);
	float w = milky_way_width;
	float n = sky_fbm3(dir * 4.0 + 4.0, 5);
	float n2 = sky_fbm3(dir * 10.0 + 13.0, 4);
	float wob = (n - 0.5) * w * 0.9;
	float core = exp(-(d + wob) * (d + wob) / (w * w));
	float wide = exp(-d * d / (w * w * 6.0));
	float lane = exp(-(d - wob * 0.6) * (d - wob * 0.6) / (w * w * 0.05)) * smoothstep(0.35, 0.65, sky_fbm3(dir * 3.0 + 40.0, 3));
	float glow = core * (0.45 + 0.75 * n2) + wide * 0.18;
	glow *= 1.0 - lane * 0.75;
	band = core;
	vec3 col = mix(sky_lin(milky_way_color_a), sky_lin(milky_way_color_b), smoothstep(0.3, 0.75, n * 0.6 + n2 * 0.5));
	return col * glow * milky_way_intensity * 0.35;
}

vec3 sky_aurora(vec3 dir, float t, float y) {
	vec3 acc = vec3(0.0);
	if (y <= 0.0) {
		return acc;
	}
	float jit = sky_hash12(dir.xz * 517.3 + dir.y * 91.7);
	for (int i = 0; i < 24; i++) {
		float fi = (float(i) + jit) / 24.0;
		float h = 1.0 + fi * 1.6;
		vec2 p = dir.xz / (y + 0.06) * h * 0.35 * aurora_scale;
		float warp = sky_gnoise(p * 0.35 + vec2(t * aurora_speed * 0.05, 3.0));
		float line = sky_gnoise(vec2(p.x * 0.45 + warp * 1.6, p.y * 0.12) + vec2(0.0, t * aurora_speed * 0.02));
		float ribbon = exp(-abs(line) * 22.0);
		float rays = 0.65 + 0.35 * sky_gnoise(vec2(p.x * 6.0 + warp * 4.0, t * aurora_speed * 0.3));
		vec3 col = mix(sky_lin(aurora_color_a), sky_lin(aurora_color_b), fi * fi * 1.4);
		acc += col * ribbon * rays * (1.0 - fi) * (1.0 - fi);
	}
	acc /= 24.0;
	acc *= smoothstep(0.0, 0.12, y) * (1.0 - smoothstep(0.55, 1.0, y) * 0.8);
	return acc * aurora_intensity * 6.0;
}

// returns rgb = colour, a = coverage
vec4 sky_planet(vec3 dir, vec3 sun_dir) {
	vec3 pd = normalize(planet_direction);
	vec3 t;
	vec3 b;
	sky_basis(pd, t, b);
	float cosd = dot(dir, pd);
	if (cosd < 0.0) {
		return vec4(0.0);
	}
	float rad = tan(radians(planet_size * 0.5));
	vec2 q = vec2(dot(dir, t), dot(dir, b)) / cosd / rad;
	float r2 = dot(q, q);
	vec4 res = vec4(0.0);
	float aa = 0.02;
	// ring (behind part first)
	float ca = cos(planet_ring_angle);
	float sa = sin(planet_ring_angle);
	vec2 rq = vec2(ca * q.x - sa * q.y, sa * q.x + ca * q.y);
	float er = length(vec2(rq.x, rq.y / planet_ring_tilt));
	float ring = 0.0;
	if (planet_ring > 0.0) {
		ring = smoothstep(1.25, 1.32, er) * (1.0 - smoothstep(2.25, 2.35, er));
		float gaps = 0.55 + 0.45 * sin(er * 38.0) * sin(er * 11.0 + 1.0);
		ring *= gaps * planet_ring;
		ring *= 1.0 - smoothstep(1.9, 1.96, er) * (1.0 - smoothstep(2.0, 2.06, er)) * 0.8;
	}
	vec3 ring_col = sky_lin(planet_ring_color);
	bool ring_front = rq.y < 0.0;
	if (!ring_front && ring > 0.0) {
		res = vec4(ring_col * 0.85, ring * 0.9);
	}
	float disc = 1.0 - smoothstep(1.0 - aa, 1.0 + aa, sqrt(r2));
	if (disc > 0.0) {
		float z = sqrt(max(1.0 - r2, 0.0));
		vec3 n = normalize(q.x * t + q.y * b - z * pd);
		float lit = dot(n, normalize(sun_dir));
		float shade = mix(smoothstep(-0.25, 0.6, lit), 1.0, planet_emission);
		float lat = q.y + 0.15 * sky_gnoise(q * 3.0 + 7.0);
		float bands = 0.5 + 0.5 * sin(lat * 9.0 + sky_gnoise(q * 2.0) * 2.5);
		vec3 base = mix(sky_lin(planet_color_a), sky_lin(planet_color_b), mix(0.5, bands, planet_bands));
		base *= 0.85 + 0.3 * sky_fbm(q * 5.0 + 3.0, 3.0, 0.0);
		vec3 atmo = sky_lin(planet_atmosphere_color) * pow(1.0 - z, 3.0) * 0.9;
		vec3 pc = base * (0.06 + 0.94 * shade) + atmo * (0.3 + shade);
		pc = mix(pc, base * 1.15, planet_emission);
		res.rgb = mix(res.rgb, pc, disc);
		res.a = max(res.a, disc);
	}
	// glow around the disc
	float halo = exp(-max(sqrt(r2) - 1.0, 0.0) * 9.0) * (1.0 - disc);
	vec3 halo_col = sky_lin(planet_atmosphere_color) * halo * (0.25 + 0.75 * planet_emission);
	if (ring_front && ring > 0.0) {
		float lit_ring = 0.55 + 0.45 * smoothstep(-0.6, 0.6, dot(normalize(rq.x * t + rq.y * b), normalize(sun_dir)));
		res.rgb = mix(res.rgb, ring_col * lit_ring, ring * 0.9);
		res.a = max(res.a, ring * 0.9);
	}
	res.rgb += halo_col * (1.0 - res.a);
	res.a = max(res.a, 0.0);
	return res * vec4(vec3(planet_intensity), min(planet_intensity, 1.0));
}

// rgb colour, a coverage
vec4 sky_clouds(vec3 dir, vec3 ld, float t, float octaves, float y, float sun_dot) {
	if (cloud_coverage <= 0.001 || y <= 0.0) {
		return vec4(0.0);
	}
	vec2 uv = dir.xz / (y + cloud_curvature) * 0.9 * cloud_scale;
	uv.x /= cloud_stretch;
	uv += cloud_wind * t + vec2(cloud_seed * 7.31, cloud_seed * 3.17);
	float lod = 1.0 - smoothstep(0.02, 0.35, y);
	vec2 wp = vec2(sky_fbm(uv * 0.45 + 1.7, 3.0, 0.0), sky_fbm(uv * 0.45 + 9.2, 3.0, 0.0)) - 0.5;
	vec2 w = uv + wp * cloud_warp * 1.4;
	float n = mix(sky_fbm(w, octaves, lod), sky_billow(w * 0.8, octaves, lod) - 0.27, cloud_billow);
	float thr = mix(0.74, 0.26, cloud_coverage);
	float soft = cloud_softness * (1.0 + lod * 2.5);
	float mask = smoothstep(thr - soft, thr + soft, n);
	if (mask <= 0.0) {
		return vec4(0.0);
	}
	vec2 l2 = ld.xz;
	float ll = length(l2);
	l2 = ll > 0.0001 ? l2 / ll : vec2(0.0);
	float lat = 1.0 - clamp(ld.y, 0.0, 1.0) * 0.7;
	float nl = mix(sky_fbm(w, 3.0, 0.0), sky_billow(w * 0.8, 3.0, 0.0) - 0.27, cloud_billow);
	vec2 ws = w + l2 * 0.16 * lat;
	float ns = mix(sky_fbm(ws, 3.0, 0.0), sky_billow(ws * 0.8, 3.0, 0.0) - 0.27, cloud_billow);
	float light = 0.62 + (nl - ns) * 4.0 * cloud_shading;
	float depth = smoothstep(thr - 0.02, thr + 0.3, nl);
	light -= depth * (0.15 + cloud_thickness * 0.7);
	light += (n - nl) * 1.2;
	light = clamp(light, 0.0, 1.0);
	light = sky_toon(light, cloud_steps);
	vec3 col = mix(sky_lin(cloud_shadow_color), sky_lin(cloud_light_color), light);
	float edge = 1.0 - smoothstep(thr, thr + 0.07 + soft, n);
	float toward = pow(max(sun_dot, 0.0), 6.0);
	col = mix(col, sky_lin(cloud_rim_color), clamp(edge * (toward * 1.2 + 0.1) * cloud_rim, 0.0, 1.0));
	col += sky_lin(cloud_rim_color) * pow(max(sun_dot, 0.0), 60.0) * 0.25 * cloud_rim;
	float fade = smoothstep(0.0, cloud_horizon_fade + 0.001, y);
	return vec4(col, mask * cloud_opacity * fade);
}

// stylized cumulus towers standing on the horizon: a height field of soft puffs
// (smooth union of domes, eroded by noise), lit through its normal. Seamless around the view.
float sky_smax(float a, float b, float k) {
	float h = clamp(0.5 + 0.5 * (a - b) / k, 0.0, 1.0);
	return mix(b, a, h) + k * h * (1.0 - h);
}

float sky_bank_field(float az, float el, float fL, vec3 dir, float fine, out float rr) {
	float N = floor(bank_count * (1.0 + fL * 0.9));
	float cw = TAU / N;
	float size = cw * bank_height * (fL == 0.0 ? 1.05 : (fL == 1.0 ? 0.78 : 0.55));
	float ci = floor(az / cw);
	float H = -1.0;
	bool any_p = false;
	rr = size;
	for (int k = -3; k <= 3; k++) {
		float j = ci + float(k);
		float jm = mod(j, N);
		vec3 h = sky_hash33(vec3(jm * 1.13, fL * 17.0 + bank_seed * 3.7, 3.1 + bank_seed));
		float ac = (j + 0.5 + (h.x - 0.5) * 0.8) * cw;
		float macro = sky_gnoise(vec2(cos(ac), sin(ac)) * 1.5 + vec2(bank_seed * 0.37 + fL * 3.0, 1.3)) * 1.0 + 0.5;
		macro = clamp(macro, 0.0, 1.0);
		if (h.y > bank_coverage * (0.3 + 1.2 * macro)) {
			continue;
		}
		float r0 = min(size * mix(0.7, 1.3, h.z) * mix(0.45, 1.3, macro), cw * 1.2);
		for (int q = 0; q < 4; q++) {
			float fq = float(q);
			vec3 g = sky_hash33(vec3(jm, fL * 5.0 + fq * 11.0, bank_seed + 7.0));
			if (q > 0 && g.z < 0.2) {
				continue;
			}
			float r = q == 0 ? r0 : r0 * mix(0.4, 0.7, g.x);
			float side = q == 1 ? -1.0 : (q == 2 ? 1.0 : (g.y - 0.5) * 0.8);
			float cx = ac + (q == 0 ? 0.0 : side * r0 * mix(0.4, 0.75, g.y));
			float cy = bank_base + (q == 0 ? r0 * 0.15 : (q == 3 ? r0 * mix(0.75, 1.05, g.z) : r0 * mix(0.35, 0.7, g.z)));
			float dx = az - cx;
			float dy = el - cy;
			float d2 = dx * dx + dy * dy;
			float hi = (r * r - d2) / (2.0 * r);
			H = any_p ? sky_smax(H, hi, size * 0.2) : hi;
			any_p = true;
		}
	}
	if (!any_p) {
		return -1.0;
	}
	// erosion: fluffy edges and inner lumps
	vec3 ep = dir * (7.0 / bank_height) * (1.0 + fL * 0.5) + vec3(fL * 7.0, bank_seed, 0.0);
	float e = (sky_fbm3(ep, 2) - 0.5) * mix(0.5, 1.0, fine);
	if (fine > 0.0) {
		e += (sky_fbm3(ep * 4.0 + 3.0, 3) - 0.5) * 0.35 * fine;
	}
	H += e * size * 0.4;
	// flat base
	H = min(H, (el - bank_base) * 1.5);
	return H;
}

vec4 sky_bank(vec3 dir, vec3 ld, float y, float sun_dot) {
	if (bank_coverage <= 0.001 || y < bank_base - 0.01 || y > 0.8) {
		return vec4(0.0);
	}
	float az = atan(dir.x, -dir.z) + PI;
	float el = asin(clamp(y, -1.0, 1.0));
	vec3 S = normalize(ld);
	vec4 acc = vec4(0.0);
	vec3 shadow = sky_lin(cloud_shadow_color);
	vec3 lightc = sky_lin(cloud_light_color);
	vec3 rimc = sky_lin(cloud_rim_color);
	vec3 hazec = sky_lin(haze_color);
	float a0 = az - PI;
	vec3 D = vec3(sin(a0), 0.0, -cos(a0));
	vec3 T = vec3(cos(a0), 0.0, sin(a0));
	vec3 Ls = normalize(vec3(dot(S, T), S.y, dot(S, -D)) + vec3(0.0, 0.25, 0.0));
	float back = max(-Ls.z, 0.0);
	for (int L = 0; L < 3; L++) {
		float fL = float(L);
		float rr;
		float H = sky_bank_field(az, el, fL, dir, 1.0, rr);
		if (H <= -0.004) {
			continue;
		}
		float aa = 0.0022;
		float cov = smoothstep(-aa, aa, H);
		float eps = 0.004;
		float r2;
		vec3 dx3 = normalize(dir + T * eps);
		vec3 dy3 = normalize(dir + vec3(0.0, eps, 0.0));
		float Hs = sky_bank_field(az, el, fL, dir, 0.0, r2);
		float Hx = sky_bank_field(mod(az + eps, TAU), el, fL, dx3, 0.0, r2);
		float Hy = sky_bank_field(az, el + eps, fL, dy3, 0.0, r2);
		vec2 gr = vec2(Hx - Hs, Hy - Hs) / eps;
		vec3 n = normalize(vec3(-gr * 1.4, 1.0));
		float diff = dot(n, Ls);
		float light = clamp(0.5 + 0.65 * diff * cloud_shading, 0.0, 1.0);
		light *= mix(0.6, 1.0, smoothstep(bank_base, bank_base + rr * 0.8, el));
		light = sky_toon(light, cloud_steps);
		vec3 col = mix(shadow, lightc, light);
		float edge = 1.0 - smoothstep(0.0, rr * 0.08, H);
		float rim = edge * (0.25 + back * 1.6) * cloud_rim;
		rim += pow(max(sun_dot, 0.0), 10.0) * 0.5 * cloud_rim * (1.0 - n.z * 0.5);
		col = mix(col, rimc, clamp(rim, 0.0, 1.0));
		col = mix(col, hazec, bank_haze * (1.0 - fL * 0.45) * 0.75);
		acc.rgb = mix(acc.rgb, col, cov);
		acc.a = max(acc.a, cov);
	}
	return acc * vec4(1.0, 1.0, 1.0, cloud_opacity);
}

// overhead cumulus: clusters of soft puffs on the cloud plane, lit through the height-field normal
float sky_cumulus_field(vec2 p, float fine) {
	vec2 ci = floor(p);
	float H = -1.0;
	bool any_p = false;
	for (int j = -1; j <= 1; j++) {
		for (int i = -1; i <= 1; i++) {
			vec2 c = ci + vec2(float(i), float(j));
			vec3 h = sky_hash33(vec3(c, cumulus_seed + 13.0));
			float macro = sky_gnoise(c * 0.37 + vec2(cumulus_seed * 0.71, 0.5));
			if (h.z > cumulus_coverage * (1.0 + 0.9 * macro)) {
				continue;
			}
			vec2 ctr = c + 0.5 + (h.xy - 0.5) * 0.3;
			float r0 = mix(0.28, 0.42, fract(h.x * 7.7 + h.y)) * (0.85 + 0.2 * cumulus_coverage);
			for (int q = 0; q < 5; q++) {
				float fq = float(q);
				vec3 g = sky_hash33(vec3(c, fq + cumulus_seed * 3.0));
				vec2 o = vec2(0.0);
				float r = r0;
				if (q > 0) {
					float ang = fq * 1.57 + g.x * 1.2;
					o = vec2(cos(ang), sin(ang)) * r0 * mix(0.55, 0.95, g.y);
					r = r0 * mix(0.45, 0.75, g.z);
				}
				vec2 dd = p - (ctr + o);
				float hi = (r * r - dot(dd, dd)) / (2.0 * r);
				H = any_p ? sky_smax(H, hi, 0.08) : hi;
				any_p = true;
			}
		}
	}
	if (!any_p) {
		return -1.0;
	}
	float e = (sky_fbm(p * 2.3 + cumulus_seed, 2.0, 0.0) - 0.5) * mix(0.5, 1.0, fine);
	if (fine > 0.0) {
		e += (sky_fbm(p * 7.0 + 3.0, 3.0, 0.0) - 0.5) * 0.4 * fine;
	}
	return H + e * 0.22;
}

vec4 sky_cumulus(vec3 dir, vec3 ld, float t, float y, float sun_dot) {
	if (cumulus_coverage <= 0.001 || y <= 0.0) {
		return vec4(0.0);
	}
	float k = 1.0 / (y + cloud_curvature);
	vec2 p = dir.xz * k * 0.9 * cumulus_scale + cloud_wind * t * 1.4 + vec2(cumulus_seed * 5.1, 2.0);
	float H = sky_cumulus_field(p, 1.0);
	if (H <= -0.05) {
		return vec4(0.0);
	}
	float aa = 0.0028 * 0.9 * cumulus_scale * k * k + 0.004;
	float cov = smoothstep(-aa, aa, H);
	if (cov <= 0.0) {
		return vec4(0.0);
	}
	float eps = 0.02;
	float Hs = sky_cumulus_field(p, 0.0);
	float Hx = sky_cumulus_field(p + vec2(eps, 0.0), 0.0);
	float Hy = sky_cumulus_field(p + vec2(0.0, eps), 0.0);
	vec3 n = normalize(vec3(-(Hx - Hs) / eps, -(Hy - Hs) / eps, 1.0));
	vec2 l2 = ld.xz;
	float ll = length(l2);
	l2 = ll > 0.0001 ? l2 / ll : vec2(0.0);
	vec3 L = normalize(vec3(l2 * 0.9, 0.45));
	float light = clamp(0.5 + 0.6 * dot(n, L) * cloud_shading - Hs * cloud_thickness * 1.5, 0.0, 1.0);
	light = sky_toon(light, cloud_steps);
	vec3 col = mix(sky_lin(cloud_shadow_color), sky_lin(cloud_light_color), light);
	float edge = 1.0 - smoothstep(0.0, 0.035 + aa, H);
	float toward = pow(max(sun_dot, 0.0), 6.0);
	col = mix(col, sky_lin(cloud_rim_color), clamp(edge * (toward * 1.3 + 0.15) * cloud_rim, 0.0, 1.0));
	float fade = smoothstep(0.0, cloud_horizon_fade + 0.04, y);
	return vec4(col, cov * cloud_opacity * fade);
}

vec4 sky_cirrus(vec3 dir, float t, float y) {
	if (cirrus_coverage <= 0.001 || y <= 0.0) {
		return vec4(0.0);
	}
	vec2 uv = dir.xz / (y + cloud_curvature * 2.0 + 0.1) * 2.2 * cirrus_scale;
	float ca = cos(cirrus_angle);
	float sa = sin(cirrus_angle);
	uv = vec2(ca * uv.x - sa * uv.y, sa * uv.x + ca * uv.y);
	uv += cloud_wind * t * 0.6 + vec2(cloud_seed * 2.1 + 40.0, cloud_seed * 5.3);
	float lod = 1.0 - smoothstep(0.02, 0.3, y);
	float warp = sky_fbm(uv * 0.25 + 3.0, 3.0, 0.0) - 0.5;
	vec2 su = vec2(uv.x / cirrus_stretch, uv.y) + vec2(0.0, warp * 0.9);
	float n = sky_fbm(su * vec2(1.0, 2.6), 6.0, lod);
	float thr = mix(0.66, 0.42, cirrus_coverage);
	float sw = 0.035 + lod * 0.08;
	float strokes = smoothstep(thr, thr + sw, n) * (0.55 + 0.45 * smoothstep(thr, thr + 0.18, n));
	float patches = smoothstep(mix(0.6, 0.2, cirrus_coverage), mix(0.66, 0.3, cirrus_coverage), sky_fbm(uv * 0.12 + 11.0, 3.0, 0.0));
	float m = strokes * patches;
	float fade = smoothstep(0.0, 0.1, y);
	return vec4(sky_lin(cirrus_color), m * cirrus_opacity * fade);
}

vec4 sky_moon(vec3 dir, vec3 md) {
	if (moon_size <= 0.0) {
		return vec4(0.0);
	}
	vec3 t;
	vec3 b;
	sky_basis(md, t, b);
	float cosd = dot(dir, md);
	if (cosd < 0.0) {
		return vec4(0.0);
	}
	float rad = tan(radians(moon_size * 0.5));
	vec2 q = vec2(dot(dir, t), dot(dir, b)) / cosd / rad;
	float r = length(q);
	float disc = 1.0 - smoothstep(0.97, 1.03, r);
	if (disc <= 0.0) {
		return vec4(0.0);
	}
	float z = sqrt(max(1.0 - r * r, 0.0));
	vec3 n = vec3(q, z);
	float a = moon_phase * PI;
	vec3 L = normalize(vec3(sin(a), 0.25 * sin(a), cos(a)));
	float lit = smoothstep(-0.06, 0.06, dot(n, L));
	float mare = smoothstep(0.42, 0.62, sky_fbm(q * 1.6 + 5.0, 4.0, 0.0));
	float crater = smoothstep(0.55, 0.75, sky_fbm(q * 5.0 + 11.0, 3.0, 0.0));
	float surf = 1.0 - moon_craters * (mare * 0.32 + crater * 0.18);
	surf *= 0.82 + 0.18 * z;
	vec3 c = sky_lin(moon_color) * surf * moon_intensity;
	vec3 dark = sky_lin(moon_color) * 0.02 * moon_intensity;
	vec3 col = mix(dark, c, lit);
	float alpha = disc * mix(moon_dark_side, 1.0, lit);
	return vec4(col, alpha);
}

vec3 stylized_sky(vec3 dir, vec3 sun_dir, vec3 moon_dir, float t, float octaves) {
	dir = normalize(dir);
	sun_dir = normalize(sun_dir);
	moon_dir = normalize(moon_dir);
	float y = dir.y - horizon_offset;
	float sun_dot = dot(dir, sun_dir);

	// gradient
	vec3 hz = sky_lin(horizon_color);
	vec3 col;
	if (y >= 0.0) {
		float a = smoothstep(0.0, horizon_width, y);
		float bz = smoothstep(horizon_width * 0.4, zenith_height, y);
		col = mix(hz, sky_lin(sky_color), a);
		col = mix(col, sky_lin(zenith_color), bz);
	} else {
		col = mix(hz, sky_lin(ground_color), smoothstep(0.0, ground_blend, -y));
	}

	// sun glow and horizon glow on the sun side
	float ang2 = max(2.0 * (1.0 - sun_dot), 0.0);
	float halo = exp(-ang2 / (sun_glow_size * sun_glow_size));
	vec2 hd = normalize(dir.xz + vec2(0.0001));
	vec2 hs = normalize(sun_dir.xz + vec2(0.0001));
	float side = pow(dot(hd, hs) * 0.5 + 0.5, mix(12.0, 1.5, horizon_glow_spread));
	float band = exp(-abs(y) / 0.11);
	float g = clamp(halo * sun_glow_intensity + side * band * horizon_glow, 0.0, 1.0);
	col = mix(col, sky_lin(sun_glow_color), g * 0.85);
	col += sky_lin(sun_glow_color) * halo * sun_glow_intensity * 0.15;

	// night layers
	if (milky_way_intensity > 0.0 || star_intensity > 0.0) {
		float mw_band = 0.0;
		vec3 mw = vec3(0.0);
		if (milky_way_intensity > 0.0) {
			mw = sky_milky_way(dir, mw_band);
		}
		float sfade = smoothstep(0.0, star_horizon_fade + 0.001, y);
		col += mw * sfade;
		if (star_intensity > 0.0) {
			col += sky_stars(dir, t, mw_band * min(milky_way_intensity, 1.0)) * star_intensity * sfade;
		}
	}
	if (aurora_intensity > 0.0) {
		col += sky_aurora(dir, t, y);
	}

	// planet / second moon
	if (planet_intensity > 0.0) {
		vec4 pl = sky_planet(dir, sun_dir);
		col = mix(col, pl.rgb, pl.a);
	}

	// sun disc
	if (sun_size > 0.0) {
		float ang = degrees(acos(clamp(sun_dot, -1.0, 1.0)));
		float r = sun_size * 0.5;
		float disc = 1.0 - smoothstep(r * (1.0 - sun_edge) - 0.04, r + 0.04, ang);
		col = mix(col, sky_lin(sun_color) * sun_intensity, disc * step(-0.02, y));
	}

	// moon
	vec4 mo = sky_moon(dir, moon_dir);
	col = mix(col, mo.rgb, mo.a);
	if (moon_size > 0.0 && moon_glow > 0.0) {
		float mang = max(2.0 * (1.0 - dot(dir, moon_dir)), 0.0);
		float mr = radians(moon_size * 0.5);
		col += sky_lin(moon_glow_color) * exp(-sqrt(mang) / (mr * 3.0 + 0.02)) * moon_glow * 0.5 * (1.0 - mo.a);
	}

	// clouds: high cirrus, then the main layer
	vec3 ld = sun_dir.y > -0.08 ? sun_dir : moon_dir;
	vec4 ci = sky_cirrus(dir, t, y);
	vec3 ci_col = ci.rgb + sky_lin(sun_glow_color) * halo * 0.5;
	col = mix(col, ci_col, ci.a);
	vec4 cl = sky_clouds(dir, ld, t, octaves, y, dot(dir, ld));
	col = mix(col, cl.rgb, cl.a);
	vec4 cu = sky_cumulus(dir, ld, t, y, dot(dir, ld));
	col = mix(col, cu.rgb, cu.a);
	cl.a = max(cl.a, cu.a);
	vec4 bk = sky_bank(dir, ld, y, dot(dir, ld));
	col = mix(col, bk.rgb, bk.a);
	cl.a = max(cl.a, bk.a);

	// haze at the horizon
	float hz_k = y >= 0.0 ? exp(-y / haze_height) : 1.0;
	col = mix(col, sky_lin(haze_color), hz_k * haze_amount);

	if (lightning_flash > 0.0) {
		col += vec3(0.55, 0.6, 0.8) * lightning_flash * (0.25 + cl.a * 0.9) * smoothstep(-0.1, 0.2, y);
	}

	col *= exposure;
	float luma = dot(col, vec3(0.2126, 0.7152, 0.0722));
	col = max(mix(vec3(luma), col, saturation), vec3(0.0));
	return col;
}
