{"code": "//Based on patriciogv\n// http://patriciogonzalezvivo.com\n\n#ifdef GL_FRAGMENT_PRECISION_HIGH\nprecision mediump float;\n#else\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\nuniform sampler2D backbuffer;\n\n#define PI 3.14159265359\n\n\nvoid main(void) {\n  vec2 st = gl_FragCoord.xy / resolution.xy-0.5;\n  float koeff = resolution.y/resolution.x;\n  st.y *= koeff;\n  float u_time = 9.;\n\n  // cartesian to polar coordinates\n  float radius = length(st);\n  float a = atan(st.x, st.y);\n\tradius += a*a/42.0;\n\t//gl_FragColor = vec4(a*a/10.);return;\n\n  // Repeat side acoriding to angle\n  float sides = 8.;\n  float ma = mod(a, PI*2.0/sides);\n  ma = abs(ma - PI/sides);\n\n  // polar to cartesian coordinates\n  st = radius * vec2(cos(ma), sin(ma));\n\n  st += cos(log2(0.1*u_time)+radius*PI-ma*koeff);\n  st = fract(st+u_time);\n  st.x = smoothstep(0.0,1.0, st.x);\n  st.y = smoothstep(1.0,0.0, st.y);\n  vec4 color = vec4(st.x, st.y, sin(u_time/(radius+ma)), 1.0);\n  color = min(color, smoothstep(0.55, 0.33,\tradius));\n  gl_FragColor = (length(color*vec4(3,0,0,0))*0.5+0.5*color)*(color.g-color.b*0.5);\n\t#define S2(D) (texture2D(backbuffer, (D+gl_FragCoord.xy)/resolution))\n\tgl_FragColor = max( (S2(vec2(0,-3))+S2(vec2(-2,0))+S2(vec2(0,1))*1.5+S2(vec2(0,5))/2.+S2(vec2(2,0)))*.2 , gl_FragColor)-1./256.;\n}\n", "user": "8dacf50", "parent": "/e#47405.0", "id": 47417}