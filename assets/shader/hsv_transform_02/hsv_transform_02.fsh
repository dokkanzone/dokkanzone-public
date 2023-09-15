varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
vec3 toHSV(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 toRGB(vec3 hsv){
    vec4 t = vec4(0.333, 0.60, 1.0, 3.0);

    vec3 p = abs(fract(vec3(hsv.r) + t.xyz) * 6.0 - vec3(t.w));
    return hsv.b * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), hsv.g);
}
void main()
{
    // みどりっぽいシェーダー
    vec4 c = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
    vec3 hsv = toHSV(c.rgb);
    hsv.r = 0.075;
    hsv.g = clamp(0.1, hsv.g - 0.2, 0.2);
    hsv.b = clamp(0.0, hsv.b , 0.97);
    float t = (0.1 - hsv.b);

    gl_FragColor = vec4(toRGB(hsv) +  t * t * vec3(0.78, 0.78, 0.30) * 0.5, c.a);
}