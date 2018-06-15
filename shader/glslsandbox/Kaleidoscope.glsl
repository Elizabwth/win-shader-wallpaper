{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n#define time (time + 100.0)\n#define PI 3.14159265358979323846\n\nfloat box(vec2 _st, vec2 _size, float _smoothEdges){\n    _size = vec2(1.75)-_size*0.75;\n    vec2 aa = vec2(_smoothEdges*0.5);\n    vec2 uv = smoothstep(_size,_size+aa,_st);\n    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);\n    return uv.x*uv.y;\n}\n\nvec2 tile(vec2 _st, float _zoom){\n    _st *= _zoom;\n    return fract(_st);\n}\n\nvec2 rotate2D(vec2 _st, float _angle, vec2 shift){\n    _st -= 0.5 + shift.x;\n    _st =  mat2(cos(_angle),-sin(_angle),\n                sin(_angle),cos(_angle)) * _st;\n    _st += 0.5 + shift.y;\n    return _st;\n}\n\nvoid main(void){\n\tvec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 5.0;\n\tvec2 vv = v; vec2 vvv = v;\n\tfloat tm = time*0.15;\n\tvec2 mspt = (vec2(\n\t\t\tsin(tm)+cos(tm*0.2)+sin(tm*0.5)+cos(tm*-0.4)+sin(tm*1.3),\n\t\t\tcos(tm)+sin(tm*0.1)+cos(tm*0.8)+sin(tm*-1.1)+cos(tm*1.5)\n\t\t\t)+15.0)*0.03;\n\t\n\t\n\tvec2 simple = (vec2(sin(tm), cos(tm)) + 1.5) * 0.15;\n\tfloat R = 0.0;\n\tfloat RR = 0.0;\n\tfloat RRR = 0.0;\n\tfloat a = (.6-simple.x)*6.2;\n\tfloat C = cos(a);\n\tfloat S = sin(a);\n\tvec2 xa=vec2(C, -S);\n\tvec2 ya=vec2(S, C);\n\tvec2 shift = vec2( 1.2, 1.62);\n\tfloat Z = 1.0 + simple.y*6.0;\n\tfloat ZZ = 1.0 + (simple.y)*6.2;\n\tfloat ZZZ = 1.0 + (simple.y)*6.9;\n\t\n\tvec2 b = gl_FragCoord.xy/(resolution);\n\tb = rotate2D(b, PI*Z, 0.05*xa);\n\t//b = vec2(box(b,vec2(1.1),0.95));\n\t\n\tfor ( int i = 0; i < 25; i++ ){\n\t\tfloat br = dot(b,b);\n\t\tfloat r = dot(v,v);\n\t\tif ( r > sin(tm) + 3.0 )\n\t\t{\n\t\t\tr = (sin(tm) + 3.0)/r ;\n\t\t\tv.x = v.x * r + 0.;\n\t\t\tv.y = v.y * r + 0.;\n\t\t}\n\t\tif ( br > 0.75 )\n\t\t{\n\t\t\tbr = (0.56)/br ;\n\t\t\t//v.x = v.x * r + 0.;\n\t\t\t//v.y = v.y * r + 0.;\n\t\t}\n\t\t\n\t\tR *= 1.05;\n\t\tR += br;//b.x;\n\t\tif(i < 24){\n\t\t\tRR *= 1.05;\n\t\t\tRR += br;//b.x;\n\t\t\tif(i <23){\n\t\t\t\tRRR *= 1.05;\n\t\t\t\tRRR += br;//b.x;\n\t\t\t}\n\t\t}\n\t\t\n\t\tv = vec2( dot(v, xa), dot(v, ya)) * Z + shift;\n\t\t//b = vec2( dot(b.xy, xa), dot(b.xy, ya)) * Z + shift;\n\t\t//b = rotate2D(vec2( dot(v, xa), dot(v, ya)), PI*Z, ya);\n\t\t//b = vec2( dot(b, xa), dot(b, ya));\n\t\tb = vec2(box(v,vec2(5.),0.9)) + shift * 0.42;\n\t}\n\tfloat c = ((mod(R,2.0)>1.0)?1.0-fract(R):fract(R));\n\tfloat cc = ((mod(RR,2.0)>1.0)?1.0-fract(RR):fract(RR));\n\tfloat ccc = ((mod(RRR,2.0)>1.0)?1.0-fract(RRR):fract(RRR));\n\tgl_FragColor = vec4(ccc,cc,c, 1.0);\n}", "user": "c63bdc1", "parent": null, "id": "45963.0"}