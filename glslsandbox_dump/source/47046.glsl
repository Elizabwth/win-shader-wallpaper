{"code": "\n#ifdef GL_ES\nprecision mediump float;\n#endif\n \nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n \nvoid main(void){\n\tvec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;\n\tvec2 vv = v; vec2 vvv = v;\n\tfloat tm = sin(time)*0.03;\n\tvec2 mspt = (vec2(\n\t\t\tsin(tm)+cos(tm*0.2)+sin(tm*0.5)+cos(tm*-0.4)+sin(tm*1.3),\n\t\t\tcos(tm)+sin(tm*0.1)+cos(tm*0.8)+sin(tm*-1.1)+cos(tm*1.5)\n\t\t\t)+1.0)*0.1; //5x harmonics, scale back to [0,1]\n\tfloat R = 0.0;\n\tfloat RR = 0.0;\n\tfloat RRR = 0.0;\n\tfloat a = (.6-mspt.x)*6.2;\n\tfloat C = cos(a);\n\tfloat S = sin(a);\n\tvec2 xa=vec2(C, -S);\n\tvec2 ya=vec2(S, C);\n\tvec2 shift = vec2( 0, 1.62*sin(time));\n\tfloat Z = 1.0 + mspt.y*6.0;\n\tfloat ZZ = 1.0 + (mspt.y)*6.2;\n\tfloat ZZZ = 1.0 + (mspt.y)*6.9;\n\t\n\tfor ( int i = 0; i < 40; i++ ){\n\t\tfloat r = dot(v,v);\n\t\tif ( r > 1.0 )\n\t\t{\n\t\t\tr = (1.0)/r ;\n\t\t\tv.x = v.x * r;\n\t\t\tv.y = v.y * r;\n\t\t}\n\t\tR *= .99;\n\t\tR += r;\n\t\tif(i < 39){\n\t\t\tRR *= .99;\n\t\t\tRR += r;\n\t\t\tif(i < 38){\n\t\t\t\tRRR *= .99;\n\t\t\t\tRRR += r;\n\t\t\t}\n\t\t}\n\t\t\n\t\tv = vec2( dot(v, xa), dot(v, ya)) * Z + shift;\n\t}\n\tfloat c = ((mod(R,2.0)>1.0)?1.0-fract(R):fract(R));\n\tfloat cc = ((mod(RR,2.0)>1.0)?1.0-fract(RR):fract(RR));\n\tfloat ccc = ((mod(RRR,2.0)>1.0)?1.0-fract(RRR):fract(RRR));\n\tgl_FragColor = vec4(sin(time), cc, c, 1.0); \n}\n", "user": "d4731ad", "parent": "/e#37015.0", "id": 47046}