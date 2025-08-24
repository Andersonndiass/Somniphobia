shader_type canvas_item;
render_mode unshaded; // não deixe o modulate do nó influenciar

// --- obrigatórios no Godot 4 ---
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// força pixelização
uniform float pixel_size : hint_range(1.0, 256.0) = 4.0;

void fragment() {
    // usa as coords da TELA, não do ColorRect
    vec2 uv = floor(SCREEN_UV * pixel_size) / pixel_size;

    // amostra a tela; textureLod é o caminho no Godot 4
    vec4 col = textureLod(SCREEN_TEXTURE, uv, 0.0);

    COLOR = col; // cor final
}