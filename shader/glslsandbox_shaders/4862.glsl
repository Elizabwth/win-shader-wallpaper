{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// @fernozzle\n\nconst vec4 WHITE = vec4(1.);\nconst vec4 BLACK = vec4(vec3(0.), 1.);\n\nconst int SHADOW_SAMPLES = 3;\nconst float SHADOW_SIZE = 0.02;\nconst float SHADOW_STRENGTH = 0.97;\nconst float CURSOR_SCALE = 1.0;\n\nvec4 cursor(vec2 m, vec2 p, vec4 c);\nbool cursorOutline(vec2 p);\nbool cursorInterior(vec2 p);\nbool withinShadowBounds(vec2 p);\n\n\nvoid main( void ) {\n\tvec2 p = -1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy);\n\tp.x *= (resolution.x / resolution.y);\n\tvec2 m = -1.0 + 2.0 * mouse.xy;\n\tm.x *= (resolution.x / resolution.y);\n\t\n\tvec4 background = vec4(gl_FragCoord.xy / resolution.xy, 0.4, 1.0);\n\tgl_FragColor = cursor(m, p, background);\n}\n\nvec4 cursor(vec2 m, vec2 p, vec4 c){\n\tvec2 relativeP = p - m;\n\trelativeP /= CURSOR_SCALE;\n\tif(cursorInterior(relativeP)){\n\t\treturn vec4(vec3(1.), 1.);\n\t}else if(cursorOutline(relativeP)){\n\t\treturn vec4(vec3(0.), 1.);\n\t}else{\n\t\tif(withinShadowBounds(relativeP)){\n\t\t\tfor(int x = 0; x < SHADOW_SAMPLES; x++){\n\t\t\t\tfor(int y = 0; y < SHADOW_SAMPLES; y++){\n\t\t\t\t\tvec2 sampleOffset = vec2(float(SHADOW_SAMPLES/2 - x) * SHADOW_SIZE, float(y) * SHADOW_SIZE);\n\t\t\t\t\tif(cursorOutline(relativeP + vec2(0., 0.03) + sampleOffset)){\n\t\t\t\t\t\tc *= SHADOW_STRENGTH;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\treturn c;\n\t}\n}\n\nbool cursorOutline(vec2 p){\n\tbool belowPoint = (p.x > 0.) && (p.x < -p.y);\n\tbool belowBottom = (p.x > p.y + 0.43) && (p.y < -0.3);\n\tbool tail = (p.x > -0.5*p.y - 0.08) && (p.x < -0.5*p.y + 0.03)\n\t\t\t&& (p.x > 2.*p.y + 0.4) && (p.x < 2.*p.y + 1.1);\n\treturn belowPoint && !belowBottom || tail;\n}\nbool cursorInterior(vec2 p){\n\tbool belowPoint = (p.x > 0.025) && (p.x < -p.y - 0.04);\n\tbool belowBottom = (p.x > p.y + 0.39) && (p.y < -0.275);\n\tbool tail = (p.x > -0.5*p.y - 0.05) && (p.x < -0.5*p.y + 0.00)\n\t\t\t&& (p.x > 2.*p.y + 0.4) && (p.x < 2.*p.y + 1.03);\n\treturn belowPoint && !belowBottom || tail;\n}\nbool withinShadowBounds(vec2 p){\n\tfloat leftBound = -float(SHADOW_SAMPLES / 2) * SHADOW_SIZE;\n\tfloat rightBound = float(SHADOW_SAMPLES / 2) * SHADOW_SIZE + 0.3;\n\tfloat topBound = 0.;\n\tfloat bottomBound = -float(SHADOW_SAMPLES - 1) * SHADOW_SIZE-0.5;\n\treturn (p.x > leftBound) && (p.x < rightBound) && (p.y < topBound) && (p.y > bottomBound);\n}", "user": "ebbe2ae", "parent": "/e#4832.1", "id": "4862.0"}