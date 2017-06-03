float near = 1.0;
float far  = 10.0;

float linearizeDepth(float depth) {
  return (2.0 * near * far) / (far + near - depth * (far - near));
}

void main()
{
  float depth = linearizeDepth(gl_FragCoord.z)/far;
  gl_FragColor = vec4(1.0-vec3(depth), 1.0f);
}
