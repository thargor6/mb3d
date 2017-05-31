float near = 1.0;
float far  = 100.0;

float LinearizeDepth(float depth)
{
    //float z = depth * 2.0 - 1.0; // Back to NDC
    float z = depth;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

void main()
{
  float depth = LinearizeDepth(gl_FragCoord.z)/33.0;
  gl_FragColor = vec4(vec3(depth), 1.0f);
}
