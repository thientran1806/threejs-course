uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;
uniform vec3 uFishPosition; 

varying float vElevation;
varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/pointLight.glsl

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);

    // Base color
    float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
    mixStrength = smoothstep(0.0, 1.0, mixStrength);
    vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

    // Light
    vec3 light = vec3(0.0);

    light += pointLight(
        vec3(1.0),              // Light color
        10.0,                   // Intensity
        normal,                 // Normal
        vec3(0.0, 0.25, 0.0),   // Light position
        viewDirection,          // View direction
        30.0,                   // Specular power
        vPosition,              // Position
        0.95                    // Decay
    );

    // Update the fish light color in fragment shader
    light += pointLight(
    vec3(0.3, 1.0, 1.0), // Cyan light
    15.0,
    normal,
    uFishPosition,
    viewDirection,
    20.0,
    vPosition,
    1.0
    );

    color *= light;
    
    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}