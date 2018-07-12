attribute vec4 position;
attribute vec2 aTexCoord;
uniform mat4 modelViewProjectionMatrix;

varying lowp vec2 vTexCoord;

void main() {

    gl_Position = modelViewProjectionMatrix * position;
    
    vTexCoord = aTexCoord;
}
