{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//Isometric ray marching\n\nfloat x_angle = -35.264;\nfloat y_angle = 45.0;\n\nmat3 rotate(vec3 u,float a)\n{\n    float c = cos(a);\n    float s = sin(a);\n    u = normalize(u);\n    \n    vec3 c0 = vec3(c + (u.x*u.x) * (1.0-c), (u.y*u.x) * (1.0-c) + (u.z*s), (u.z*u.x) * (1.0-c) - (u.y*s));    \n    vec3 c1 = vec3((u.x*u.y) * (1.0-c) - (u.z*s), c + (u.y*u.y) * (1.0-c), (u.z*u.y) * (1.0-c) + (u.x*s)); \n    vec3 c2 = vec3((u.x*u.z) * (1.0-c) + (u.y*s), (u.y*u.z) * (1.0-c) - (u.x*s), c + (u.z*u.z) * (1.0-c));\n    \n    return mat3(c0,c1,c2);\n}\n\nfloat cube(vec3 pos, float s)\n{\n\treturn max(max(abs(pos.x),abs(pos.y)),abs(pos.z)) - s;\t\n}\n\nfloat sphere(vec3 pos, float s)\n{\n\treturn length(pos) - s;\t\n}\n\nfloat plane(vec3 pos)\n{\n\treturn pos.y;\n}\n\nfloat scene(vec3 pos)\n{\n\tfloat dist = 1e6;\n\t\n\tfloat ground = plane(pos - vec3( 0.0,-1.0, 0.0));\n\t\n\tvec3 odom = pos;\n\t\n\todom.xz = mod(odom.xz + 1.0, vec2(2.0)) - 1.0;\n\t\n\tfloat t1 = mod(time*0.8 - 0.0, 2.0);\n\tfloat t2 = mod(time*0.8 - 1.0, 2.0);\n\t\n\tfloat object = cube(odom, 0.5);\n\tobject = max(object, -sphere(odom, 0.6));\n\t\n\tobject = min(object, sphere(odom - vec3(t1 - 0.0,0,0), 0.2));\n\tobject = min(object, sphere(odom - vec3(t1 - 2.0,0,0), 0.2));\n\tobject = min(object, sphere(odom - vec3(0,0,t2 - 0.0), 0.2));\n\tobject = min(object, sphere(odom - vec3(0,0,t2 - 2.0), 0.2));\n\t\n\tdist = min(dist, ground);\n\tdist = min(dist, object);\n\t\n\treturn dist;\n}\n\nvec3 normal(vec3 pos)\n{\n\tvec2 offs = vec2(0.02,0);\n\treturn normalize(vec3(scene(pos + offs.xyy) - scene(pos - offs.xyy), scene(pos + offs.yxy) - scene(pos - offs.yxy), scene(pos + offs.yyx) - scene(pos - offs.yyx)));\n}\n\nvoid main( void ) \n{\n\tvec2 aspect = resolution.xy / min(resolution.x, resolution.y);\n\tvec2 uv = gl_FragCoord.xy / min(resolution.x, resolution.y);\n\tvec2 cen = aspect/2.0;\n\t\n\tvec3 color = vec3(0.0);\n\t\n\tmat3 rot = rotate(vec3(1,0,0),radians(x_angle));\n\trot *= rotate(vec3(0,1,0),radians(y_angle));\n\t\n\tvec3 dir = vec3(0,0,1) * rot;\n\tvec3 pos = (vec3((uv - cen) * 4.0,-8.0)) * rot;\n\t\n\tfor(int i = 0;i < 64;i++)\n\t{\n\t\tfloat dist = scene(pos);\n\t\tpos += dir * dist;\n\t\t\n\t\tif(dist < 0.001){break;}\n\t}\n\t\n\tvec3 norm = normal(pos);\n\t\n\tcolor = (norm * 0.5 + 0.5) * max(0.0,-dot(norm, dir));\n\t\n\tgl_FragColor = vec4( vec3( color ), 1.0 );\n\n}", "user": "a8250a4", "parent": null, "id": "27147.2"}