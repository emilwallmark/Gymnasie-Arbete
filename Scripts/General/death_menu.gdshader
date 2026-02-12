shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float amount : hint_range(0.0, 5.0);
uniform float red_strength : hint_range(0.0, 1.0) = 0.15; // how red it gets

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, amount);

    // Subtle red tint
    color.rgb *= vec3(1.1, 0.95, 0.95);

    COLOR = color;
}