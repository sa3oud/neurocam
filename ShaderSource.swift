let lsdShader = """
#include <metal_stdlib>
using namespace metal;

vertex float4 vertexPass(uint vid [[vertex_id]]) {
    float2 positions[] = { {-1,1}, {1,1}, {-1,-1}, {1,-1} };
    return float4(positions[vid], 0, 1);
}

fragment float4 fragmentPass(VertexOut in [[stage_in]],
                              texture2d<float, access::sample> u_camera [[texture(0)]]) {
    constexpr sampler s;
    float2 uv = in.position.xy * 0.5 + 0.5;
    // kaleidoscope
    float2 p = uv * 2.0 - 1.0;
    float a = atan2(p.y, p.x) + get_time();
    float r = length(p);
    uv = float2(cos(a), sin(a)) * r;
    // chromatic drift
    float drift = 0.01;
    float3 c;
    c.r = u_camera.sample(s, uv + float2(drift,0)).r;
    c.g = u_camera.sample(s, uv).g;
    c.b = u_camera.sample(s, uv - float2(drift,0)).b;
    c *= 0.9 + 0.1 * sin(get_time()*2);
    return float4(c, 1);
}
"""
