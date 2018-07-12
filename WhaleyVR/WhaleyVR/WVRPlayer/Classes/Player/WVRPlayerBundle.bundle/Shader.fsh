uniform sampler2D uSampler;
varying lowp vec2 vTexCoord;

void main()
{
    lowp vec4 texCol = texture2D(uSampler, vTexCoord); 
    
    gl_FragColor = texCol;
}
