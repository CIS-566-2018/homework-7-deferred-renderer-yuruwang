#version 300 es
precision highp float;

in vec4 fs_Pos;
in vec4 fs_Nor;
in vec4 fs_Col;
in vec2 fs_UV;


out vec4 fragColor[3]; // The data in the ith index of this array of outputs
                       // is passed to the ith index of OpenGLRenderer's
                       // gbTargets array, which is an array of textures.
                       // This lets us output different types of data,
                       // such as albedo, normal, and position, as
                       // separate images from a single render pass.

uniform sampler2D tex_Color;


void main() {
    // TODO: pass proper data into gbuffers
    // Presently, the provided shader passes "nothing" to the first
    // two gbuffers and basic color to the third.

    
    vec3 col = texture(tex_Color, fs_UV).rgb;

    // if using textures, inverse gamma correct
    col = pow(col, vec3(2.2));

    // pass Camera-space depth of the fragment and World-space surface normal of the fragment to first texture
    fragColor[0] = vec4(fs_Nor.xyz, fs_Pos[3]);
    // fragColor[0] = vec4(0.0);

    // maybe pass the information of background
    fragColor[1] = vec4(1.0);


    // pass (base color) of the fragment to the third texture
    fragColor[2] = vec4(col, 1.0);
}
