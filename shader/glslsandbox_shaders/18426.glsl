{"code": "// cleaned up the code + some minor tweaks --novalis\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\nfloat sdBox(vec3 p, vec3 b) {\n\tvec3 d = abs(p) - b;\n\treturn min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));\n}\n\nfloat sdCross(vec3 p) {\n\treturn min(sdBox(p, vec3(1e38, 1., 1.)), min(sdBox(p, vec3(1., 1e38, 1.)), sdBox(p, vec3(1., 1., 1e38))));\n}\n\nfloat dist2nearest(vec3 p) {\n\tvec3 q = mod(p, 1.0) - .5;\n\treturn sdCross(q * 27.) / 27.;\n}\n\nvoid main() {\n\tvec3 camDir = vec3(gl_FragCoord.xy / resolution.xy, 1.) * 2. - 1.;\n\tcamDir.x *= resolution.x / resolution.y;\n\tcamDir = normalize(camDir);\n\t\n\tvec3 camPos = vec3(sin(time/3.), cos(time/2.), sin(time/2.));\n\t\n\tfloat t = 0., d = 2e-6;\n\tint j = 0;\n\t\n\tfor(int i = 0; i < 64; i++) {\n\t\tif(abs(d) < 1e-6 || t > 64.) continue;\n\t\td = dist2nearest(camPos + t * camDir);\n\t\tt += d;\n\t\tj = i;\n\t}\n\t\n\tfloat col = 0.;\n\tif(abs(d) < 1e-6) col = 1.-float(j)/64.;\n\t\n\tgl_FragColor = vec4(vec3(col), 1.);\n}", "user": "1abcee3", "parent": "/e#18424.0", "id": "18426.0"}