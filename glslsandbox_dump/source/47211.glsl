{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/XlXGWf\n */\n\n//#define ANIMANDELPRO\n//#define BOXPLORER2\n//#define FRAGMENTARIUM\n//#define SHADERTOY\n#define GLSLSANDBOX\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nfloat DERRect(in vec3 z, vec4 radii){return length(max(abs(z)-radii.xyz,0.0))-radii.w;}\nfloat DERect(in vec2 z, vec2 r){return max(abs(z.x)-r.x,abs(z.y)-r.y);}\nfloat DEEiffie(in vec3 z){\n\tfloat d1=DERect(z.yz,vec2(0.25,0.9));//I\n\tfloat d2=min(DERect(z.xz,vec2(0.25,0.9)),min(DERect(z.xz+vec2(0.25,0.7),vec2(0.5,0.2)),DERect(z.xz+vec2(0.25,0.0),vec2(0.5,0.2))));//F\n\tfloat d3=min(DERect(z.xy,vec2(0.25,0.9)),min(DERect(z.xy+vec2(0.25,0.7),vec2(0.5,0.2)),min(DERect(z.xy+vec2(0.25,0.0),vec2(0.5,0.2)),DERect(z.xy+vec2(0.25,-0.7),vec2(0.5,0.2)))));//E\n\treturn min(d1,min(d2,d3));\n}\n\nfloat DE(in vec3 z){\n\treturn max(DERRect(z,vec4(0.95,0.95,0.95,0.05)),-DEEiffie(z));\n}\nfloat sinNoise3d(in vec3 p){\n\tfloat s=0.5,r=0.0;\n\tfor(int i=0;i<3;i++){\n\t\tp+=p+sin(p.yzx*0.8+sin(p.zxy*0.9));\n\t\ts*=0.5;\n\t\tr+=sin(p.z+1.5*sin(p.y+1.3*sin(p.x)))*s;\n\t}\n\treturn r;\n}\nfloat volLiteMask(vec3 rd){\n\tvec3 ar=abs(rd);\n\tvec2 pt;\n\tfloat d=100.0;\n\tif(ar.x>ar.y && ar.x>ar.z)pt=rd.yz/ar.x;\n\telse{\n\t\tif(ar.y>ar.z)pt=rd.xz/ar.y;\n\t\telse {\n\t\t\tpt=rd.xy/ar.z;\n\t\t\td=DERect(pt+vec2(0.25,-0.7),vec2(0.5,0.2));\n\t\t}\n\t\td=min(d,min(DERect(pt+vec2(0.25,0.7),vec2(0.5,0.2)),DERect(pt+vec2(0.25,0.0),vec2(0.5,0.2))));\n\t}\n\td=min(d,DERect(pt,vec2(0.25,0.9)));\n\treturn (d<0.0)?1.0:0.0;\n}\nfloat rand(vec2 c){return fract(sin(c.x+2.4*sin(c.y))*34.1234);}\nmat3 lookat(vec3 fw){\n\tfw=normalize(fw);vec3 rt=normalize(cross(-fw,vec3(0.0,1.0,0.0)));return mat3(rt,cross(rt,fw),fw);\n}\nvec4 scene(vec3 ro, vec3 rd) {\n\tfloat t=0.0,d=0.0;\n\tfor(int i=0;i<48;i++){\n\t\tt+=d=DE(ro+rd*t);\n\t\tif(t>10.0 || d<0.01)break;\n\t}\n\tfloat lt=pow(dot(rd,normalize(-ro)),10.0);\n\tfloat t2=0.2*rand(gl_FragCoord.xy);\n\tvec3 sum=vec3(0.0);\n\tfor(int i=0;i<48;i++){\n\t\tt2+=0.2+t2*t2*0.01;\n\t\t//if((t2>t && d<0.2) || t2>100.0)break;\n        if(t2>t && d<0.2)break;\n        //t2=min(t2,10.0);\n        if(t2>9.0)t2-=0.75+0.25*sin(float(i*2));\n\t\tvec3 vr=normalize(ro+rd*t2);\n\t\tif(vr==vr)sum+=(vr*0.5+0.5)*volLiteMask(vr)*(0.1+0.2*sinNoise3d((ro+rd*t2)));\n\t}\n\tvec3 col=clamp(lt*sum,0.0,1.0);\n\treturn vec4(col,t);\n}\nvoid AnimateCamera(in vec2 uv, in float tym, inout vec3 ro, inout vec3 rd){\n\tro=vec3(cos(tym),sin(tym*0.7),sin(tym))*4.0;\n\trd=lookat(vec3(sin(tym*0.8),cos(tym*0.3),0.0)-ro)*normalize(vec3(uv,1.0));\n}\n#ifdef ANIMANDELPRO\nvarying vec3 dir; //from vertex shader\nuniform vec3 eye; //camera position\nuniform ivec2 size;//size of image in pixels\nuniform float time;//timing\nvoid main(){\n\tvec2 uv=(2.0*gl_FragCoord.xy-size.xy)/size.y;\n\tvec3 ro,rd;\n\t//AnimateCamera(uv, time, ro, rd);\n\tvec3 ro=eye,rd=normalize(dir);\n\tvec4 scn=scene(ro,rd);\n\tgl_FragColor = vec4(scn.rgb,1.0);\n}\n#endif\n#ifdef BOXPLORER2\n//#include \"setup.inc\"\nvoid main(){\n\tvec3 ro,rd;\n\tif (!setup_ray(eye, dir, ro, rd)) return;\n\tvec4 scn=scene(ro,rd);\n\twrite_pixel(dir, scn.a, scn.rgb);\n}\n#endif\n#ifdef FRAGMENTARIUM\n//#include \"3DKn-1.0.1.frag\"\nvec3 color(SRay Ray){\n\tvec4 scn=scene(Ray.Origin, Ray.Direction);\n\treturn scn.rgb;\n}\n#endif\n#ifdef SHADERTOY\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n\tvec2 uv=(2.0*fragCoord.xy-iResolution.xy)/iResolution.y;\n\tvec3 ro,rd;\n\tAnimateCamera(uv, iTime, ro, rd);\n\tvec4 scn=scene(ro,rd);\n\tfragColor = vec4(scn.rgb,1.0);\n}\n#endif\n#ifdef GLSLSANDBOX\nuniform float time;\nuniform vec2 resolution;\nvoid main(){\n\tvec2 uv=(2.0*gl_FragCoord.xy-resolution.xy)/resolution.y;\n\tvec3 ro,rd;\n\tAnimateCamera(uv, time, ro, rd);\n\tvec4 scn=scene(ro,rd);\n\tgl_FragColor= vec4(scn.rgb,1.0);\n}\n#endif", "user": "8ae668d", "parent": null, "id": 47211}