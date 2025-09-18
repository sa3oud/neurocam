// LSD-25.frag  (MIT-0)
precision highp float;
uniform sampler2D u_camera;      // live camera feed
uniform vec2      u_resolution;  // viewport
uniform float     u_time;        // seconds
uniform float     u_intensity;   // 0.0-1.0 UI slider

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    
    // classic kaleidoscope base
    vec2 p = uv * 2.0 - 1.0;
    float a = atan(p.y, p.x) + u_time * 0.3;
    float r = length(p);
    uv = vec2(cos(a), sin(a)) * r;
    
    // chromatic drift
    float drift = 0.01 * u_intensity;
    vec4 c;
    c.r = texture2D(u_camera, uv + vec2(+drift, 0.0)).r;
    c.g = texture2D(u_camera, uv).g;
    c.b = texture2D(u_camera, uv + vec2(-drift, 0.0)).b;
    c.a = 1.0;
    
    // breathing brightness
    c.rgb *= 0.9 + 0.1 * sin(u_time * 2.0);
    
    gl_FragColor = c;
}
