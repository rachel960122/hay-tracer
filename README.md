# Hay Tracer

### Compile and Run
Please compile the program using the compiler with the high optimization flag: ghc -O2 Main.hs
The program can be run as ./Main [input file] (eg. ./Main test1.in)

We provide six test input files in the input folder with their corresponding sample output images rendered from our HayTracer.

Current Hay Tracer supports Sphere and Plane rendering, both solid colored and checkerboard textured objects, ambient, diffuse and specular shading, and both reflection and refraction. Further improvements include supporting more objects and Parallelize the program so that we can support anti-aliasing(super-sampling using 9 rays per pixel to reduce blurring edges)

---


### Input and Output Format
Input:
- The input file is accepted as command line argument
- Example usage: `./Main test.in` where `test.in` is the name of the input file
- Contents of the input file:
  - **line 1:** name of the output file
  - **line 2:** 2 integers denoting the width and height of the final image
  - **Camera:**
    - **line 3 - 6:** camera and view parameters, including the coordinates of the camera, the point the camera is looking at, the up vector, and the *y*-field of view in degrees
  - **Light Sources:**
    - **line 7:** number of light sources *nl*
    - **next *nl* lines:** each contains 9 floating point numbers: the *(x, y, z)* coordinates of the light source, the RGB components of its intensity, and the *(a, b, c)* components of the attenuation formula *1/(a+bd+cd^2)*.
  - **Pigments:**
    - **next line:** number of pigments *np*
    - **next *np* lines:** each contains the description of one pigment (solid/checkerboard). Each pigment can be thought of as a function that takes a surface point *(x,y,z)* and maps it to an RGB value
  - **Surface Finishes:**
    - **next line:** number of surface finishes *nf*
    - **next *nf* lines:** each contains the description of one set of surface finish parameters. Each surface finish consists of the following seven values: the ambient coefficient *ka*, diffuse coefficient *kd*, specular coefficient *ks*, the shininess *α*, reflectivity coefficient *kr*, transmission coefficient *kt*, and the index of refraction *ηt*.
  - **Objects:**
    - **next line:** number of objects *m*
    - **next *m* lines:** each line contains the descriptions of an object. The first integer corresponds to the pigment number (integer between 0 and *np* − 1) and the second integer corresponds to the surface finish number (between 0 and *nf* − 1). Next comes the type of the object, as one of the following:
    - The word **sphere** followed by the center point coordinates *(x, y, z)* and the radius *r*.
    - The word **plane** followed by a tuple of floating-point values *(a, b, c, d)*, which represents the half space inequality *ax + by + cz + d* ≤ 0. For example, the plane defined by the inequality *z* ≤ −2 would be given by the tuple (0, 0, 1, 2).

Output:
- The output file is in PPM P6 format (binary PPM).
- Contents of the output file:
  - **line 1:** the string "P6"
  - **line 2:** the width and height of the image
  - **line 3:** the integer 255
  - **the rest of the file:** RGB values per pixel, three bytes per pixel (in binary). The pixels are written row by row, from top to bottom and from left to right.


---

### Major functions
`DataTypes.hs` contains the definitions of data types used in the project:
- `Vec3`, `Point`, `Color`, `Vec4`, `Vector2`, `Vector3`
- `Object`
- `Camera`
- `Image`
- `Light`
- `Ray`
- `Pigment`
- `PhongCoef`
- `Surface`


`Util.hs` contains the following functions:
1. **Vector operations:**
   - `minus`
   - `plus`
   - `plus3` (add three `Vec3`s together)
   - `vlength` (length of a vector)
   - `mult` (multiplication of corresponding components of two `Vec3`s)
   - `multScalar` (scalar-vector multiplication)
   - `dot` (dot product)
   - `cross` (cross product)
   - `normalize`
2. **Other utility functions:**
   - `reflect` (calculate reflection vector)
   - `vdistance` (distance between two `Point`s)
   - `radians` (degrees to radians)
   - `clampVec` (calls clamp and clamps the Color within (0,0,0) and (255,255,255))
   - `clamp`


`IO.hs` contains the following functions:
1. **Reading input file:**
   - `readImage`
   - `readCamera`
   - `readLights`
   - `readPigments`
   - `readSurfaces`
   - `readObjects`
2. **Writing to output file:**
   - `writePPM6`
   - `writePPM` (`String` to output file)
   - `stringPPM` (`Word8` to `ByteString`)
3. **Calculating intersections and normals:**
   - `getIntersect`
   - `getNormal`


`HayTrace.hs` contains the following functions:
- `constructRay` (construct ray from image dimension and camera info)
- `sendRay` (construct and trace the ray for each pixel)
- `viewTransform` (perform view transformation similar to glm::lookAt)
- `calcDiffuse` (calculate the diffuse color in phong model)
- `calcSpecular` (calculate the specular color in phong model)
- `lit` (sum of diffuse and specular)
- `phong` (sum of diffuse/specular color combination from each light on top of the initial ambient color in phong model)
- `reflection` (recursively trace the reflection ray)
- `refraction` (recursively trace the refraction ray)
- `trace` (sum of phong shading, reflection and refraction)


`Main.hs` contains the following function:
- `main` (reads input and pass data to `sendRay` function, which returns an array of pixels that gets
  written to output by `writePPM6` function)

---

### Reflections
- What Went Well
  - version control and collaboration through Github
  - I/O
  - rewrite C code in idiomatic Haskell
      Originally we still think imperatively and follow the Ray Tracing algorithm which traverse through every image pixel using double for loops, so our initial attempt for the sendRay and phong functions used many tedious recursions.
      Later on, we refactored those two functions using higher order functions and list comprehensions using the functional paradigm as follows:
        - sendRay uses list comprehension to construct ray and trace each constructed ray for every image   pixel
        - phong uses higher order functions including `foldr` and `map` to shade each pixel as the sum of diffuse and specular color combination from each light source on top of the initial ambient color, using the phong model.
- What Went Poorly
  - struggling with different types of Strings:
      Initially we tried directly converting `Double` to `ByteString` and write the resulting `ByteString`s to the output file. For some reason, the output contained plain strings, contrary to what we understood about `ByteString`s. We also converted `Double` to `ByteString` the wrong way: We first converted `Double` to `String`, then used `pack` to convert `String` to `Internal.String`, then used `fromChunks` to convert `Internal.String` to `String`. The entire process was confusing and the code ended up very inefficient. However, things got much better after we converted `Double` to `Word8` and packed `Word8` into `ByteString`. We do get why this works and this is more efficient, but we are not sure why the original solution did not output binary strings.
  - debugging:
      we made a few simple mistakes in our code, and ended up spending lots of time incorporating the `trace` function from `Debug.Trace` package into our code and change it back after fixing the bugs. We did successfully find the bug and it looks like using the `trace` function is one of easiest way of debugging, but it was a bit more time-consuming than we thought and required minor changes to the structure of our code.
- What Can Be Improved
  - Add support for more objects such as polyhedron and triangular meshes
  - Parallelize the code for better performance
  - Implement antialiasing to have smoother edges
  - Currently if the input file is invalid, we choose to terminate the program with helpful error messages aiming to help user reformat their input file, however, we are wondering if there are better ways to catch and handle the input file exceptions.
