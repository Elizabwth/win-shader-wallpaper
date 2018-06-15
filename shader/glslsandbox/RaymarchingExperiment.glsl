{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// a raymarching experiment by kabuto\n//fork by tigrou ind (2013.01.22)\n// slow mod by kapsy1312.tumblr.com\n// grid destruction by echophon\n\nconst int MAXITER = 16;\n\nvec3 field(vec3 p) {\n\tp *= .1;\n\tfloat f = .1;\n\tfor (int i = 0; i < 5; i++) {\n\t\tp = p.yzx; //*mat3(.8,.6,0,-.8,.8,6,6,0,1);\n//\t\tp += vec3(.123,.456,.789)*float(i);\n\t\tp = abs(fract(p)-.5);\n\t\tp *= 2.;\n\t\tf *= 2.;\n\t}\n\tp *= p;\n\treturn sqrt(p+p.yzx)/f-.01;\n\t//return sqrt(p+p.yzx)/f-.05;\n}\n\nvoid main( void ) {\n\tvec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));\n\tfloat a = time * 0.071;\n\tvec3 pos = vec3(0.5,time*0.05,time*-0.025);\n\t//camera\n\tdir *= mat3(1,0,0,0,cos(a),-sin(a),0,sin(a),cos(a));\n\tdir *= mat3(cos(a),0,-sin(a),0,1,0,sin(a),0,cos(a));\n\tvec3 color = vec3(0);\n\tfor (int i = 0; i < MAXITER; i++) {\n\t\tvec3 f2 = field(pos);\n\t\tfloat f = min(min(f2.x,f2.y),f2.z);\n\t\t\n\t\tpos += (dir*f)*2.;\n\t\t//pos += dir*f;\n\t\tcolor += float(MAXITER-i)/(f2+.01);\n\t}\n\t//vec3 color3 = vec3(1.-1./(1.+color*(.1/float(MAXITER*MAXITER))));\n\tvec3 color3 = vec3(1.-1./(1.2+color*(.09/float(MAXITER*MAXITER))));\n\tcolor3 *= color3;\n\t//gl_FragColor = pow(vec4(vec3(1.003) - vec3(3.0-color3.r+color3.g+color3.b),1.), vec4(0.7));\n\tgl_FragColor = vec4(vec3(color3.r+color3.g+color3.b),3.);\n}", "user": "405dd21", "parent": "/e#23759.6", "id": "24014.0"}