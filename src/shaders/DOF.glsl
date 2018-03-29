#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962


in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;

uniform float u_Time;
uniform vec2 u_Dimensions;

uniform mat4 u_View;
uniform vec4 u_CamPos;   

uniform float u_focus;

float fovy = 45.0 * 3.1415962 / 180.0;

vec3 lightPos = vec3(5, 5, 5); 

const float g_array[225] = float[225](

0.003026, 0.003279, 0.003509, 0.003709, 0.003873, 0.003994, 0.004069, 0.004094, 0.004069, 0.003994, 0.003873, 0.003709, 0.003509, 0.003279, 0.003026, 
0.003279, 0.003553, 0.003802, 0.004019, 0.004196, 0.004327, 0.004408, 0.004436, 0.004408, 0.004327, 0.004196, 0.004019, 0.003802, 0.003553, 0.003279, 
0.003509, 0.003802, 0.004069, 0.004301, 0.004491, 0.004631, 0.004718, 0.004747, 0.004718, 0.004631, 0.004491, 0.004301, 0.004069, 0.003802, 0.003509, 
0.003709, 0.004019, 0.004301, 0.004546, 0.004747, 0.004895, 0.004987, 0.005018, 0.004987, 0.004895, 0.004747, 0.004546, 0.004301, 0.004019, 0.003709, 
0.003873, 0.004196, 0.004491, 0.004747, 0.004956, 0.005111, 0.005207, 0.005239, 0.005207, 0.005111, 0.004956, 0.004747, 0.004491, 0.004196, 0.003873, 
0.003994, 0.004327, 0.004631, 0.004895, 0.005111, 0.005271, 0.00537, 0.005403, 0.00537, 0.005271, 0.005111, 0.004895, 0.004631, 0.004327, 0.003994, 
0.004069, 0.004408, 0.004718, 0.004987, 0.005207, 0.00537, 0.00547, 0.005504, 0.00547, 0.00537, 0.005207, 0.004987, 0.004718, 0.004408, 0.004069, 
0.004094, 0.004436, 0.004747, 0.005018, 0.005239, 0.005403, 0.005504, 0.005538, 0.005504, 0.005403, 0.005239, 0.005018, 0.004747, 0.004436, 0.004094, 
0.004069, 0.004408, 0.004718, 0.004987, 0.005207, 0.00537, 0.00547, 0.005504, 0.00547, 0.00537, 0.005207, 0.004987, 0.004718, 0.004408, 0.004069, 
0.003994, 0.004327, 0.004631, 0.004895, 0.005111, 0.005271, 0.00537, 0.005403, 0.00537, 0.005271, 0.005111, 0.004895, 0.004631, 0.004327, 0.003994, 
0.003873, 0.004196, 0.004491, 0.004747, 0.004956, 0.005111, 0.005207, 0.005239, 0.005207, 0.005111, 0.004956, 0.004747, 0.004491, 0.004196, 0.003873, 
0.003709, 0.004019, 0.004301, 0.004546, 0.004747, 0.004895, 0.004987, 0.005018, 0.004987, 0.004895, 0.004747, 0.004546, 0.004301, 0.004019, 0.003709, 
0.003509, 0.003802, 0.004069, 0.004301, 0.004491, 0.004631, 0.004718, 0.004747, 0.004718, 0.004631, 0.004491, 0.004301, 0.004069, 0.003802, 0.003509, 
0.003279, 0.003553, 0.003802, 0.004019, 0.004196, 0.004327, 0.004408, 0.004436, 0.004408, 0.004327, 0.004196, 0.004019, 0.003802, 0.003553, 0.003279, 
0.003026, 0.003279, 0.003509, 0.003709, 0.003873, 0.003994, 0.004069, 0.004094, 0.004069, 0.003994, 0.003873, 0.003709, 0.003509, 0.003279, 0.003026

);



void main() { 
	out_Col = vec4(1.0, 0.0, 0.0, 1.0);

	vec4 nor_depth = texture(u_gb0, fs_UV);
	vec3 nor = vec3(nor_depth.xyz);
	float depth = nor_depth[3];


//----------------------Guassian-----------------------
	float n = 15.0;  //15 x 15 Gaussian filter kernel	
    float sigma = 20.0;    // sigmal of Gaussian filter
    float g;    // a coefficient of Gaussian filter

	vec3 sum = vec3(0, 0, 0);   // averaged sum of Gaussian filtering
    vec2 UV;    // UV coordinate of neighbor pixel
    vec2 screenCoor;    // screen coord of current fragment
    int num = 0;

	float coeff = 0.0;
	coeff= abs(u_focus - depth) * 5.0;


	for(float i = (-1.0) * (n / 2.0); i <= n / 2.0; i++) {
		for(float j = (-1.0) * (n / 2.0); j <= n / 2.0; j++) {
			screenCoor = vec2(gl_FragCoord.x + j * coeff, gl_FragCoord.y + i * coeff);
			UV = vec2(screenCoor.x / u_Dimensions.x, screenCoor.y / u_Dimensions.y);

			g = g_array[num];
			sum = sum + texture(u_gb2, UV).xyz * g;

			num++;
		}
	}
	out_Col = vec4(sum * 1.5, 1.0);

}





