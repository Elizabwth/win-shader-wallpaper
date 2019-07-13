{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvarying vec3 positionSurface;\nvarying vec3 positionSize;\n\nconst int MAX_ITER = 30; // \n\nvec2 rotate(in vec2 v, in float a) {\n\treturn vec2(cos(a)*v.x + sin(a)*v.y, -sin(a)*v.x + cos(a)*v.y);\n}\n\nfloat torus(in vec3 p, in vec2 t)\n{\n\tvec2 q = abs(vec2(max(abs(p.x), abs(p.z))-t.x, p.y));\n\treturn max(q.x, q.y)-t.y;\n}\n\n// These are all equally interesting, but I could only pick one :(\nfloat trap(in vec3 p)\n{\n\t#define var1 abs(max(abs(p.z)-0.1, abs(p.x)-0.1))-0.01\n\t#define var2 length(max(abs(p.xy) - 0.05, 0.0))\n\t#define var3 length(p)-0.5\n\t#define var4 length(max(abs(p) - 0.35, 0.0))\n\t#define var5 abs(length(p.xz)-0.2)-0.01\n\t#define var6 abs(min(torus(vec3(p.x, mod(p.y,0.4)-0.2, p.z), vec2(0.1, 0.05)), max(abs(p.z)-0.05, abs(p.x)-0.05)))-0.005\n\t#define var7 abs(min(torus(p, vec2(0.3, 0.05)), max(abs(p.z)-0.05, abs(p.x)-0.05)))-0.005\n\t#define var8 min(length(p.xz), min(length(p.yz), length(p.xy))) - 0.05\n\t\n\treturn  abs(max(abs(p.z)-0.1, abs(p.x)-0.1))-0.01;\n\t\n}\n\nfloat map(in vec3 p)\n{\n\tfloat cutout = dot(abs(p.yz),vec2(0.5))-0.035;\n\t\n\tvec3 z = abs(1.0-mod(p,2.0));\n\tz.yz = rotate(z.yz, time*0.05);\n\n\tfloat d = 999.0;\n\tfloat s = 1.0;\n\tfor (float i = 0.0; i < 3.0; i++) {\n\t\tz.xz = rotate(z.xz, radians(i*10.0+time));\n\t\tz.zy = rotate(z.yz, radians((i+1.0)*20.0+time*1.1234));\n\t\tz = abs(1.0-mod(z+i/3.0,2.0));\n\t\t\n\t\tz = z*2.0 - 0.3;\n\t\ts *= 0.5;\n\t\td = min(d, trap(z) * s);\n\t}\n\treturn min(max(d, -cutout), 1.0);\n}\n\nvec3 hsv(in float h, in float s, in float v) {\n\treturn mix(vec3(1.0), clamp((abs(fract(h + vec3(3, 2, 1) / 3.0) * 6.0 - 3.0) - 1.0), 0.0 , 1.0), s) * v;\n}\n\nvec3 intersect(in vec3 rayOrigin, in vec3 rayDir)\n{\n\tfloat total_dist = 0.0;\n\tvec3 p = rayOrigin;\n\tfloat d = 1.0;\n\tfloat iter = 0.0;\n\tfloat mind = 3.14159+sin(time*0.1)*0.2;\n\t\n\tfor (int i = 0; i < MAX_ITER; i++)\n\t{\t\t\n\t\tif (d < 0.001) continue;\n\t\t\n\t\td = map(p);\n\t\tp += d*vec3(rayDir.x, rotate(rayDir.yz, sin(mind)));\n\t\tmind = min(mind, d);\n\t\ttotal_dist += d;\n\t\titer++;\n\t}\n\n\tvec3 color = vec3(0.0);\n\tif (d < 0.001) {\n\t\tfloat x = (iter/float(MAX_ITER));\n\t\tfloat y = (d-0.01)/0.01/(float(MAX_ITER));\n\t\tfloat z = (0.01-d)/0.01/float(MAX_ITER);\n\t\tif (max(abs(p.y-0.025), abs(p.z)-0.035)<0.002) { // Road\n\t\t\tfloat w = smoothstep(mod(p.x*50.0, 4.0), 2.0, 2.01);\n\t\t\tw -= 1.0-smoothstep(mod(p.x*50.0+2.0, 4.0), 2.0, 1.99);\n\t\t\tw = fract(w+0.0001);\n\t\t\tfloat a = fract(smoothstep(abs(p.z), 0.0025, 0.0026));\n\t\t\tcolor = vec3((1.0-x-y*2.)*mix(vec3(0.8, 0.1, 0), vec3(0.1), 1.0-(1.0-w)*(1.0-a)));\n\t\t} else {\n\t\t\tfloat q = 1.0-x-y*2.+z;\n\t\t\tcolor = hsv(q*0.2+0.85, 1.0-q*0.2, q);\n\t\t}\n\t} else\n\t\tcolor = hsv(d, 1.0, 1.0)*mind*45.0; // Background\n\treturn color;\n}\n\nvoid main()\n{\n\tvec3 upDirection = vec3(0, -1, 0);\n\tvec3 cameraDir = vec3(1,0,0);\n\tvec3 cameraOrigin = vec3(time*0.551, 0, 0);\n\t\n\tvec3 u = normalize(cross(upDirection, cameraOrigin));\n\tvec3 v = normalize(cross(cameraDir, u));\n\tvec2 screenPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution;\n\tscreenPos.x *= resolution.x / resolution.y;\n\tvec3 rayDir = normalize(u * screenPos.x + v * screenPos.y + cameraDir*(1.0-length(screenPos)*0.5));\n\t\n\tgl_FragColor = vec4(intersect(cameraOrigin, rayDir), 10.0);\n} ", "user": "2554538", "parent": "/e#27434.0", "id": "27547.5"}