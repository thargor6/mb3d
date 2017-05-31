// The input variable from the vertex shader (same name and same type, but with precision)
varying lowp vec4 vertexColor;
  
void main()
{
    gl_FragColor = vertexColor;
} 