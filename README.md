Unity3D-Shaders-Basic
=====================

Basic Unity3D Shaders

Author: Shantanu Bhadoria

Date: 2/7/2014

These are Basic Shaders built using Unity. Shader files are in Shaders folder and can be dragged and dropped into Unity Assets.Each subsequent shader adds a certain effect to the pervious shader. Shaders upto 4 are single pass shaders which means they don't support multiple light sources. 5 and onwards are multi pass shaders which combine the effects of multiple lights in the scene.

* 1 Flat Color: Flat Color shader, no effects, no reaction to ambient, directional or any other light, this is the simplest possible shader you can have. Very little Practical use. Single Pass Vertext ShaderSingle Pass
* 2 Lambert Shader: A Diffuse Shader, Reflects soft light from one light source Attenuates light reflection based on surface angle towards light source direction. no reflection, specular effects etc. Doesn't include Ambient Light in Calculations. Single Pass
* 2b Ambient Lambert Shader: Same Shader as above. Adds Ambient Light effect to output. Single Pass
* 3a Specular Shader: Adds a Specular reflection effect on top to emulate a shiny surface like metal for example in addition to base diffuse and ambient effects. Uses Vertex Shading, achieves a decent output for subdivided surface meshes. Not so good for low poly models. Single Pass
* 3b Specular Pixel Shader: like above except uses Pixel Shading. i.e. This shader calculates shader values for each pixel on each face of the mesh. Way more expensive than vertex shaders but it gives a much more beautiful output.Single Pass
* 4 Rim Shader: Adds a Rim Lighting effect to the object, Mathematically this in effect is the inverse of specular effect. Rim Shader adds extra lighting to the edge of an object.Single Pass
* 5 Multi Lights: This is a double pass shader which supports more than one lights in the scene. This Shader only supports directional lights and ambient light. It doesn't work well with point lights.
* 5b Point Lights: This Shader supports point lights in addition to directional lights.
* 6 Texture Shader: This Shader allows you to use a image texture map on your mesh to add realistic look to objects.
* 7 Normal Maps: This Shader allows you to add a normal map to the object. Normal Map is a specific image where the image pixel coordinate decides how the light is reflected on the corresponding pixel coordinate on your mesh. This allows you to give a illusion of surface bumps, gashes etc. on your mesh surface. Normal Maps is the most common kind of Bump Mapping technique.
* 8a gloss map: This shader uses the alpha channel of your texture map to decide glossiness coefficient of a surface. This coefficient is used to calculate the specular reflections across the surface. This causes certain sections of your mesh to emit less reflections than others depending on you texture images alpha channel.
* 8b emission map: This is a rarely used setting that gives a light emission on a surface irrespective of any light source. This will be rarely used except to show lightings in building windows in dark scenes like at night for example. The emission surfaces don't emit any light at the moment, They are just illuminated.
