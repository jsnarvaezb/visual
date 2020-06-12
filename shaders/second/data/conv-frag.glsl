/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*     
*   Programa que aplica una mascaras de convolucion de 3x3 a una imagen
*   Mascara es arreglo de 9 llamado mask
*/

precision mediump float;
uniform float mask[9];
uniform sampler2D texture;
uniform vec2 uTextureSize;
varying vec4 vertTexCoord;
 
void main() {
    vec2 coords = vertTexCoord.st;
    vec4 sum = vec4(0.0);
    vec2 stepSize = 1.0/(uTextureSize);    
 
    sum += mask[0] * texture2D(texture, vec2(coords.x - stepSize.x, coords.y - stepSize.y));
    sum += mask[1] * texture2D(texture, vec2(coords.x, coords.y - stepSize.y));
    sum += mask[2] * texture2D(texture, vec2(coords.x + stepSize.x, coords.y - stepSize.y)); 
    sum += mask[3] * texture2D(texture, vec2(coords.x - stepSize.x, coords.y));
    
    vec4 originalColor = texture2D(texture, vec2(coords.x, coords.y)).rgba;    
    sum += mask[4] * originalColor;    
    sum += mask[5] * texture2D(texture, vec2(coords.x + stepSize.x, coords.y)); 
    sum += mask[6] * texture2D(texture, vec2(coords.x - stepSize.x, coords.y + stepSize.y));
    sum += mask[7] * texture2D(texture, vec2(coords.x, coords.y + stepSize.y));
    sum += mask[8] * texture2D(texture, vec2(coords.x + stepSize.x, coords.y + stepSize.y)); 
    sum.a = originalColor.a; 
    gl_FragColor = sum;
}
