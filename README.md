#Computación visual

## Taller 1

Taller de análisis de imágenes/video al implementar diferentes operaciones tanto por software como por hardware(shaders), realizado por Juan Sebastian Narvaez y Diego Felipe Rodriguez para la materia Computación visual 2020-1.

### Motivación y objetivo

* Aplicar diferentes filtros y mascaras de convolución a imagenes y videos.

* Analizar y comparar los resultados...

### 1 Analisis por software

#### 1.1 Imagenes

##### 1.1.1 Metodología y resultados

###### 1.1.1.1 Mascaras de convolución

Para aplicar mascaras de convolución a la imagen, se recorre pixel por pixel y para cada uno de ellos, se multiplica su valor y el valor de los 8 pixeles adyacentes(para matrices 3x3) por la matriz de covolución del filtro deseado, asi:

![](./img/convolution-calculate.png)

Para calcular estas operaciones tenemos el siguiente código, que realiza las operaciones descritas para los valores rgb de cada pixel calculado y al final lo consolida en un solo valor de tipo *color* y lo reasigna al respectivo pixel.

```java
  for (int y = 1; y < pg.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < pg.width-1; x++) {  // Skip left and right edges
      float rtotal=0 ;
      float gtotal=0; 
      float btotal=0;
      // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*original_video.width + (x + kx);
          // Multiply adjacent pixels based on the kernel values
          rtotal += red(original_video.pixels[pos]) * matrix[ky+1][kx+1];
          gtotal += green(original_video.pixels[pos]) * matrix[ky+1][kx+1];
          btotal += blue(original_video.pixels[pos]) * matrix[ky+1][kx+1];
        }
      }
      color c = color(rtotal,gtotal,btotal);
      int i = x + y*original_video.width;
      pg.pixels[i] = c;
    }
  }
```

De esta manera, obtenemos los siguientes resultados para diferentes filtros. Se tiene un histograma para medir los niveles de brillo de la imagen filtrada.

###### 1.1.1.1.1 Identidad 

Para este filtro se utiliza la matriz de convolución: 

| 0 | 0 | 0 |
|---|---|---|
| 0 | 1 | 0 |
| 0 | 0 | 0 |

La cual no modifica ningun valor en los pixeles de la imagen, y así obtenemos el mismo resultado de la imagen original

![](./img/identity-software-image.png)

###### 1.1.1.1.2 Blur

Con el filtro blur se obtiene un efecto de difuminado sobre la imagen y utiliza la siguiente matriz de convolución:

| 0.11 | 0.11 | 0.11 |
|---|---|---|
| 0.11 | 0.11 | 0.11 |
| 0.11 | 0.11 | 0.11 |

![](./img/blur-software-image.png)

###### 1.1.1.1.3 Sharpen

El filtro Sharpen acentúa los bordes pero también cualquier ruido o mancha y utiliza la siguiente matriz de convolución:

| 0 | -1 | 0 |
|---|---|---|
| -1 | 5 | -1 |
| 0 | -1 | 0|

![](./img/sharpen-software-image.png)

###### 1.1.1.1.3 Edge detection

La detección de bordes identifica puntos en los que el brillo de la imagen cambia bruscamente. Para este filtro se utilizó la siguiente matriz de convolución:

| -1 | -1 | -1 |
|---|---|---|
| -1 | 8 | -1 |
| -1 | -1 | -1|

![](./img/edge-software-image.png)

###### 1.1.1.2 Escala de grises y Luma

Para realizar el filtro de escala de grises y luma, se recorre cada pixel de la imagen, se calculan sus valores rgb y se hacen operaciones sobre estos así:

**Escala de grises**: Se promedian los valores rgb de cada pixel. `(r+g+b)/3`

**Luma**: Se recalculan los valores rgb para el pixel multiplicando asi: `(0.2989 * r) + (0.5870 *g) + (0.1140 * b)` y se actualizan los valores.

El código que utilizamos para realizar estas operaciones es el siguiente:

```java
for (int i = 0; i < pg.pixels.length; i++) {
    float red = red(pg.pixels[i]);    
    float green = green(pg.pixels[i]);
    float blue = blue(pg.pixels[i]);
    if(filter=="grayscale"){
      pg.pixels[i] = color(int((red+green+blue)/3));
    }
    if(filter=="luma"){
      pg.pixels[i] = color((0.2989 * red) + (0.5870 *green) + (0.1140 * blue));
    }
  }
```
Y así obtenemos los siguientes resultados: 

**ESCALA DE GRISES**

![](./img/grayscale-software-image.png)

**LUMA**

![](./img/luma-software-image.png)

###### 1.1.1.3 Ascii

Se recorren todos los pixeles de la imagen, y para cada uno se le asigna un caracter ascii dependiendo del promedio de brillantez que tenga. 

Este es el código que utilizamos para calcular y mostrar la imagen en ascii

```java
int resolution = 7;
  textSize(12); 
  ascii = new char[256];
  String letters = "@&%#*vi<>+=^;,:'. ";
  for (int i = 0; i < 256; i++) {
    int index = int(map(i, 0, 256, 0, letters.length()));
    ascii[i] = letters.charAt(index);
  }
  for (int y = 5; y <original_video.height-5; y += resolution) {
    for (int x = 5; x < original_video.width-5; x += resolution) {
      int index = (x + y * pg.width);
      float r = red(pg.pixels[index + 0]);
      float g = green(pg.pixels[index + 1]);
      float b = blue(pg.pixels[index + 2]);
      float brig = (r+g+b)/3;
      text(ascii[int(brig)], x+520, y+10);
    }
  }
```

Y obtuvimos el siguiente resultado


![](./img/ascii-software-image.png)

#### 1.2 Video

##### 1.2.1 Metodología y resultados

###### 1.2.1.1 Mascaras de convolución

Se utiliza el mismo metodo que en las mascaras de convolución en imagenes y se obtienen los siguientes resultados.

###### 1.2.1.1.1 Blur

![](./img/blur-software-video.gif)

###### 1.2.1.1.2 Sharpen

![](./img/sharpen-software-video.gif)

###### 1.2.1.1.3 Edge detection

![](./img/edge-software-video.gif)

###### 1.2.1.1.4 Gaussian blur

![](./img/gaussian-software-video.gif)

###### 1.2.2.2 Escala de grises y Luma

###### 1.2.2.2.1 Escala de grises 

![](./img/grayscale-software-video.gif)

###### 1.2.2.2.2 Luma

![](./img/luma-software-video.gif)

###### 1.1.2.3 Ascii

![](./img/ascii-software-video.gif)

### 2 Analisis por hardware

#### 2.1 Metodología y resultados


### Conclusiones

