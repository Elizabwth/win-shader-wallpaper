{"code": "// this is a remake of Puls, a famous 256b intro by Rrrola\n// see here for a video: http://www.youtube.com/watch?v=R35UuntQQF8\n//\n// rendering is done with raymarching with distance fields:\n// http://goo.gl/6dZE3\n//\n// translucency is done with depth testing (smaller depth -> lighter pixel)\n//\n// the standalone version has music (Hybrid song by Axwell:\n// http://goo.gl/jPEib) and a \"beat-sync\" ;). you can get it here: \n// http://github.com/pakt/gfx. you will need a browser with webkit\n// audio api (about:flags, enable experimental apis in chrome).\n//\n// here's a capture of version with music: http://youtu.be/Kc4ZZrITBic\n//\n//e#1238.0 - raer: fixed the raymarching eps 0.1->0.005 to get rid of artifacts\n//e#1238.0 - raer: added soft shadows ala http://www.iquilezles.org/www/articles/rmshadows/rmshadows.htm\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// pk\n// twitter.com/pa_kt\nuniform float bin0;\nuniform float bin1;\nuniform float bin2;\n\n//#define FISH_EYE\n//#define FAKE_AO\n\n#define PI (4.0*atan(1.0))\n#define CELL_SIZE 3.5\n\n#define FLOOR 0.0\n#define BOX 1.0\n#define TORUS 2.0\n#define FIELD 3.0\n#define GREEN_OCTA 4.0\n#define ORANGE_OCTA 5.0\n#define BARS 6.0\n#define BOLTS 7.0\n#define SPHERE 8.0\n\nfloat fog(vec3 eye, vec3 p){\n float f = 1.0/exp(length(p)*0.05);\n return f;\n}\n\nvec2 op_union(vec2 a, vec2 b){\n if(a.x < b.x)\n  return a;\n return b;\n}\n\nvec2 op_subtract(vec2 a, vec2 b){\n if(-a.x > b.x){ \n  return vec2(-a.x, a.y);\n }\n return b;\n}\n\nvec2 op_intersect(vec2 a, vec2 b){\n if(a.x > b.x)\n  return a;\n return vec2(b.x, a.y);\n}\n\nfloat rbox_d(vec3 p, vec3 b, float r )\n{\n  return length(max(abs(p)-b,0.0))-r;\n}\n\nfloat torus_d(vec3 p, vec2 t){  \n  vec2 q = vec2(length(p.xz)-t.x,p.y);\n  return length(q)-t.y;\n}\n\nfloat sphere_d(vec3 p, float r){\n\treturn length(p)-r;\n}\n\nfloat octa_d(vec3 p, float r){\n\t//p = p/2.0;\n\tfloat d = abs(p.x)+abs(p.y)+abs(p.z);\n\td = d/2.0;\n\treturn d-r;\n}\n\n\nfloat bars_d(vec3 p, float r){\n\tfloat d = (abs(abs(p.x)-abs(p.z)) + abs(abs(p.y)-abs(p.x)) + abs(abs(p.z)-abs(p.y)));\n\td = d/4.0;\n\treturn d-r;\n}\n\nvec3 rep( vec3 p, float m )\n{\n\tvec3 c = vec3(m,m,m);\n    \tvec3 q = mod(p+c/2.0, c)-c/2.0;\n   \treturn q;\n}\n\nfloat tempo(){\n\tfloat t = 1.0;//sin(time*2.0);\n\tt = (t+1.0)/2.0;\n\treturn t;\n}\t\n\nvec2 get_octas(vec3 p, float octa_size, float cell_size, float id){\n\tvec3 q = rep(p, cell_size);\n\tvec2 o = vec2(octa_d(q, octa_size), id);\t\n\treturn o;\n}\n\nvec2 get_all_octas_dist(vec3 p, float cell_size, in float green_size, in float orange_size){\n\tvec2 green = get_octas(p, green_size, cell_size, GREEN_OCTA);\n\tvec3 r = p - cell_size/2.0;\t\n\tvec2 orange = get_octas(r, orange_size, cell_size, ORANGE_OCTA);\n\treturn op_union(green, orange);\n}\n\n// \"beat-sync\" with music\nvoid get_sizes(float t, out float green_size, out float orange_size){\n\tfloat fix0 = max(bin0-0.55, 0.0)*2.0;\n\tfloat fix1 = max(bin1-0.4, 0.0)*2.0;\n\tgreen_size = mix(0.4, 0.7, t)+fix0;\n\torange_size = mix(0.8, 0.3, t)+fix1;\n}\n\n//octas is the distance to sum of orange/green octas (without bars/bolts)\nvec2 march_step_(vec3 p, out vec2 octas){ \n\n\tfloat t = tempo();\n\tfloat cell_size = CELL_SIZE;\t\n \t\n\tvec3 q = rep(p, cell_size);\t\n\t\n\tfloat green_size = 0.0;\n\tfloat orange_size = 0.0;\n\tget_sizes(t, green_size, orange_size);\n\tvec2 green_octas =  get_octas(p, green_size, cell_size, GREEN_OCTA);\n\tvec3 offset = vec3(0,0,0)+cell_size/2.0;\n\tvec3 r = p - offset;\t\n\tvec2 orange_octas = get_octas(r, orange_size, cell_size, ORANGE_OCTA);\n\toctas = op_union(green_octas, orange_octas);\n\t\n\tvec2 bars = vec2(bars_d(q, 0.14), BARS);\n\t\n\tfloat bolt_size = 0.5;\n\tfloat bolt_offset = 0.1;\n\tfloat small_size = mix(green_size, length(offset)-orange_size-green_size, t);\n\tfloat big_size = small_size+bolt_size;\n\tvec2 bolts = vec2(bars_d(q, 0.28), BOLTS);\n\tvec2 small_octa = vec2(octa_d(q, small_size), BOLTS);\n\tvec2 big_octa = vec2(octa_d(q, big_size), BOLTS);\n\tbolts = op_intersect(bolts, big_octa);\n\tbolts = op_subtract(small_octa, bolts);\n\t\n\tvec2 o = vec2(0,0);\n\t\n\to = op_union(bars, octas);\n\to = op_union(o, bolts);\t\n\t\n\treturn o;\n}\n\nvec2 march_step(vec3 p){\n\tvec2 trash = vec2(0,0);\n\tvec2 o = march_step_(p, trash);\n\treturn o;\n}\n\nvec3 normal(float dist, vec3 p){\n\tvec2 e = vec2(0.01, 0.0);\n\tfloat dx = dist-march_step(p-e.xyy).x;\n\tfloat dy = dist-march_step(p-e.yxy).x;\n\tfloat dz = dist-march_step(p-e.yyx).x;\n      \tvec3 n = vec3(dx, dy, dz);\n\tn = normalize(n);\n\n\treturn n;\n}\n\nvec3 camera(\n  in vec3 eye,\n  in vec3 lookat,\n  in vec3 up,\n  in float fov)\n{\n\tvec2 pos = -1.0 + 2.0*( gl_FragCoord.xy / resolution.xy );\n\tfloat aspect = resolution.x / resolution.y;\n\tvec3 ray = normalize(lookat - eye);\n\t// view plane spanning vectors\n\tvec3 u = normalize(cross(up, ray));\n\tvec3 v = cross(ray, u);\n\tfov = radians(fov/2.0);\n\tfloat vp_distance = 1.0/tan(fov);\t\n\tvec3 vp_center = eye+vp_distance*ray;\n\n \tvec3 vp_point = vp_center + pos.x*u*aspect + pos.y*v;\n  \tvec3 vp_ray = normalize(vp_point - eye);\n\t\n\treturn vp_ray;\n}\n\nvec3 camera_fish(\n  in vec3 eye,\n  in vec3 lookat,\n  in vec3 up,\n  in float fov)\n{\n\tvec2 pos = -1.0 + 2.0*( gl_FragCoord.xy / resolution.xy );\n\tfloat aspect = resolution.x / resolution.y;\n\t\n\tvec3 ray = normalize(lookat - eye);\t\n\tvec3 u = normalize(cross(up, ray));\n\tvec3 v = normalize(cross(ray, u));\n\t\n\tfov = radians(fov/2.0);\t\n\tfloat w = sin(fov);\n\tfloat x = pos.x * w * aspect;\n\tfloat y = pos.y * w;\n\tfloat z = sqrt(1.0 - x*x - y*y);\n\t\n\t//vec3 vp_ray = vec3(pos.x, pos.y, z);\n\tvec3 vp_ray = (x*u+y*v+ray*z);\n\tvp_ray = normalize(vp_ray);\n\t\n\treturn vp_ray;\n}\n\n//AO technique by Alex Evans (statix)\n//http://www.iquilezles.org/www/material/nvscene2008/rwwtt.pdf\nfloat ao(vec3 p, vec3 n){\n\tfloat delta = 0.2;\n\tfloat o = 1.0;\n\tfloat d = 0.0;\n\tfloat e = 1.0;\n\tfloat s = 0.0;\n\tfor(int i=1;i<6;i++){\n\t\ts = float(i)*delta;\n\t\tp = p+n*s;\n\t\td = march_step(p).x;\n\t\td = d - s;\n\t\te *= 2.0;\n\t\to += d/e;\n\t}\n\t//o = (0.9*o);\n\t\n\treturn o;\n}\n\nvec2 ray_march(vec3 eye, vec3 ray, float eps, float min_depth, float max_depth, out vec3 p, out float f){\n\tvec2 o = vec2(eps+1.0, -1);\n\tf = min_depth;\n\n\tfor(int i=0;i<64;i++){\n\t \tif(abs(o.x)<eps){\n\t  \t\tbreak;\n\t \t}\n\t\tif(f > max_depth){\n\t\t\to.y = -1.0;\n\t\t\tbreak;\n\t\t}\n\t \tf += o.x;\n\t \tp = eye + f*ray;\n\t \to = march_step(p);\t \t\n\t}\n\treturn o;\n}\n\nfloat softshadow( vec3 pos, vec3 light, float k )\n{\n    //ray origin is shading point\n    //ray direction is shading point to light position\n    vec3 rd = light-pos;\n    float max_dist = length(rd);\n    rd = normalize(rd);\n    float res = 1.0;\n    float h = 0.0;\n    float t = 0.001;\n    for(int i=0;i<32;i++)\n    {\n        h = march_step(pos + rd*t).x;\n        if( h<0.001 )\n            return 0.0;\n        res = min( res, k*h/t );\n        t += h;\n\tif (t >= 1.0) {\n\t    break;\n\t}\n    }\n    return res;\n}\n\nvec3 gen_eye(float t){\n\tvec3 o = vec3(0,0,0);\n\to.x = cos(t/2.0)*2.0;\n\to.y = t;\n\to.z = sin(t/2.0)*2.0;\n\treturn o;\n}\n\nvoid main( void ) {\n\t\n\tvec3 up = vec3(0.0, 1.0, sin(time)*2.0);\n\tvec3 lookat = gen_eye(time+1.2); //vec3(0.0, 0.0, 0.0);\n\tvec3 eye = gen_eye(time); //vec3(CELL_SIZE/2.0, 0.0, 2.0);\n\t//vec3 eye = vec3(sin(time)+6.0, 10.0+cos(time)*2.0, sin(time)*2.0);\n\tvec3 light = eye+vec3(sin(time)*4.0, cos(time)*4.0, 0.0);\n\t\n\t\n\t#ifndef FISH_EYE\n\tfloat fov = 90.0;\n\tvec3 vp_ray = camera(eye, lookat, up, fov);\t\n\t#else\n\tfloat fov = 80.0;\n\tvec3 vp_ray = camera_fish(eye, lookat, up, fov);\t\n\t#endif\n\t\n\n\t\n\tvec3 color = vec3(0.0, 0.0, 0.0);\n\t\n\tfloat min_depth = 0.0;\n\tfloat max_depth = 20.0;\t\n\tint max_steps = 64;\n\tfloat eps = 0.005;\n\tfloat f = min_depth;\n\t\n\tvec3 p = vec3(0,0,0);\n\t\n\tvec2 o = ray_march(eye, vp_ray, eps, min_depth, max_depth, p, f);\t\n\t\n\tif(o.y!=-1.0){      \n\t\tif (o.y == BOX){\n\t\t\tcolor = vec3(0.1, 0.5, 0.2);\n\t  \t}\n\t\telse if(o.y == BARS){\n\t\t\tcolor = vec3(0.9,0.9,0.9);\n\t\t\t\n\t\t}\t\n\t\telse if(o.y == BOLTS){\n\t\t\tcolor = vec3(0.1,0.3,0.5);\n\n\t\t}\t\t\n\t\telse if(o.y == GREEN_OCTA){\n\t\t\tcolor = vec3(0.0, 1.0, 0.0);\n\t\t}\n\t\telse if(o.y == ORANGE_OCTA){\n\t\t\tcolor = vec3(1.0, 0.6, 0.0);\n\t\t}\n\t\t\n\t  \telse{\n           \t\tcolor = vec3(0.3, 0.1, 0.2);\n          \t}\t  \n\t\t\n\t   \tvec3 n = normal(o.x, p);\n           \tfloat b=dot(n, normalize(light-p));\n\t\tfloat light_value = softshadow(p, light, 16.0);\n\t   \tcolor =vec3((b*color+pow(b,5.0))*light_value);//simple phong\n\t\tcolor = color*(1.0-(f/max_depth));\n\t\t\n\t\t//float a_o = ao(p, n);\n\t\t//color = color*a_o;\n\t\t\n\t\tif(o.y == ORANGE_OCTA || o.y == GREEN_OCTA){\n\t\t\tlight = p+5.0*(vp_ray);\n\t\t\teye = p-0.01*n; //step inside the object\t\t\t\n\t\t\tvec3 ray = normalize(light - eye);\n\t\t\tif(dot(n,ray)>0.0)\n\t\t\t\tray = -ray;\n\t\t\tvec3 q = p;\n\t\t\tf = 0.0;\n\t\t\tfor(int i=0;i<64;i++){\n\t\t\t\tmarch_step_(p, o);\n\t\t\t\tif(o.x>=-0.01)\n\t\t\t\t\tbreak;\n\t\t\t\to.x = -1.0*o.x;\n\t\t\t\tf = f+o.x;\t\t\t\t\n\t\t\t\tp = eye+f*ray;\n\t\t\t}\n\t\t\tif(f>0.01){\n\t\t\t\tf = 1.0+1.0/(f);\n\t\t\t\tcolor *= f;\n\t\t\t}\t\n\t\t}\n\t }\n\t\t\n\tcolor = color * max(1.0-f*.04,0.1);\n\t//color = color * fog(eye, p);\n\n\tgl_FragColor = vec4( color, 1.0 );\n\n}\n", "user": "ceaf946", "parent": "/e#1247.0", "id": "1273.0"}