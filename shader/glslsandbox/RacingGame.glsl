{"code": "\n//---------------------------------------------------------\n// Shader:   RacingGame.glsl    by eiffie 12/2013\n// original: https://www.shadertoy.com/view/Xd23DD\n// tags:     racing, 3d, raymarching, lightning, cars\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n//---------------------------------------------------------\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n//uniform sampler2D texture;\n\n//---------------------------------------------------------\nfloat spec, specExp=8.0, pixelSize;\nconst vec3 sunColor=vec3(1.0,0.7,0.3);\nvec3 L;\n\nfloat smin(float a,float b,float k)\n{ return -log(exp(-k*a)+exp(-k*b))/k; } //from iq\n\nvec3 cp1,cp2,cp3;\nmat2 cm1,cm2,cm3;\n\nvoid PositionCars(float t)\n{\n\tfloat f=mod(t,3.1416);\n\tif(mod(t/6.283,2.0)>1.0)f=0.0;\n\tf=smoothstep(0.0,0.6,abs(f-1.4))*0.16;\n\tfloat x=cos(t)*10.0+cos(t*8.0)*0.6;\n\tfloat y=sin(t)*10.0+sin(t*3.0)*0.6;\n\tcp1=vec3(x,0.0,y);\n\tt+=0.01;\n\tx-=cos(t)*10.0+cos(t*8.0)*0.6;\n\ty-=sin(t)*10.0+sin(t*3.0)*0.6;\n\tfloat a=atan(x,y);\n\tcm1=mat2(cos(a),sin(a),-sin(a),cos(a));\n\tt+=0.09;\n\tx=cos(t)*10.0+cos(t*8.0)*0.725;\n\ty=sin(t)*10.0+sin(t*3.0)*0.725;\n\tcp2=vec3(x,0.0,y);\n\tt+=0.01;\n\tx-=cos(t)*10.0+cos(t*8.0)*0.725;\n\ty-=sin(t)*10.0+sin(t*3.0)*0.725;\n\ta=atan(x,y);\n\tcm2=mat2(cos(a),sin(a),-sin(a),cos(a));\n\tt+=f-0.04;\n\tx=cos(t)*10.0+cos(t*8.0)*0.45;\n\ty=sin(t)*10.0+sin(t*3.0)*0.45;\n\tcp3=vec3(x,0.0,y);\n\tt+=0.01;\n\tx-=cos(t)*10.0+cos(t*8.0)*0.45;\n\ty-=sin(t)*10.0+sin(t*3.0)*0.45;\n\ta=atan(x,y);\n\tcm3=mat2(cos(a),sin(a),-sin(a),cos(a));\n}\nvec3 rc=vec3(0.7,0.26,1.5);\nfloat DE(in vec3 z0)\n{\n\tfloat a=atan(z0.z,z0.x);\n\tfloat g=(sin(z0.x+sin(z0.z*1.7))+sin(z0.z+sin(z0.x*1.3)))*0.2;\n\tfloat d=abs(length(z0.xz-vec2(cos(a*8.0),sin(a*3.0))*0.75)-10.0)-0.4;\n\tfloat dg=z0.y+g*smoothstep(0.0,0.5,d);\n\tvec3 c,p=z0,prp=vec3(0.0);\n\tfloat d0=100.0;\n\t\n\tc=(z0-cp1)*10.0;c.xz=cm1*c.xz;\n\tfloat dt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;prp=vec3(1.21,0.4,1.97);}\n\tc=(z0-cp2)*10.0;c.xz=cm2*c.xz;\n\tdt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;prp=vec3(1.12,0.35,1.92);}\n\tc=(z0-cp3)*10.0;c.xz=cm3*c.xz;\n\tdt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;prp=vec3(0.61,0.26,1.48);}\n\n\tif(d0<dg*10.0)\n\t{\t\n\t\tfloat r=length(p.yz+vec2(prp.x,0.0));\n\t\td0=length(max(vec3(abs(p.x)-prp.y,r-prp.z,-p.y+0.16),0.0))-0.05;\n\t\td0=max(d0,p.z-1.0);\n\t\tp+=vec3(0.0,-0.25,0.39);\n\t\tp.xz=abs(p.xz);\n\t\tp.xz-=vec2(0.5300,0.9600);\n\t\tp.x=abs(p.x);\n\t\tr=length(p.yz);\n\t\td0=smin(d0,length(max(vec3(p.x-0.08,r-0.25,-p.y-0.08),0.0))-0.04,8.0);\n\t\td0=max(d0,-max(p.x-0.165,r-0.24));\n\t\tfloat d2=length(vec2(max(p.x-0.13,0.0),r-0.2))-0.02;\n\t\tfloat d3=min(max(p.x-0.05,r-0.18),length(vec2(max(p.x-0.11,0.0),r-0.18))-0.02);//length(vec2(max(p.x-0.11,0.0),r-0.18))-0.02;\n\t\td0=min(d0,min(d2,d3));\n\t}\n\treturn min(dg,d0*0.1);\n}\n\nvec3 clr=vec3(0.0);\nfloat CE(in vec3 z0)\n{\n\tfloat a=atan(z0.z,z0.x);\n\tfloat g=(sin(z0.x+sin(z0.z*1.7))+sin(z0.z+sin(z0.x*1.3)))*0.2;\n\tfloat d=abs(length(z0.xz-vec2(cos(a*8.0),sin(a*3.0))*0.75)-10.0)-0.4;\n\tfloat dg=(z0.y+g*smoothstep(0.0,0.5,d))*10.0;\n\tvec3 c,p=z0,col=vec3(0.0),prp=vec3(0.0);\n\tfloat d0=100.0;\n\t\n\tc=(z0-cp1)*10.0;c.xz=cm1*c.xz;\n\tfloat dt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;col=vec3(1.0,0.0,0.0);prp=vec3(1.21,0.4,1.97);}\n\tc=(z0-cp2)*10.0;c.xz=cm2*c.xz;\n\tdt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;col=vec3(0.0,1.0,0.0);prp=vec3(1.12,0.35,1.92);}\n\tc=(z0-cp3)*10.0;c.xz=cm3*c.xz;\n\tdt=length(max(vec3(0.0),abs(c)-rc))-0.1;\n\tif(dt<d0){d0=dt;p=c;col=vec3(0.0,0.0,1.0);prp=vec3(0.61,0.26,1.48);}\n\n\tif(d0<dg)\n\t{\t\n\t\tvec3 p0=p;\n\t\tfloat r=length(p.yz+vec2(prp.x,0.0));\n\t\td0=length(max(vec3(abs(p.x)-prp.y,r-prp.z,-p.y+0.16),0.0))-0.05;\n\t\td0=max(d0,p.z-1.0);\n\t\tp+=vec3(0.0,-0.25,0.39);\n\t\tp.xz=abs(p.xz);\n\t\tp.xz-=vec2(0.5300,0.9600);\n\t\tp.x=abs(p.x);\n\t\tr=length(p.yz);\n\t\td0=smin(d0,length(max(vec3(p.x-0.08,r-0.25,-p.y-0.08),0.0))-0.04,8.0);\n\t\td0=max(d0,-max(p.x-0.165,r-0.24));\n\t\tfloat d2=length(vec2(max(p.x-0.13,0.0),r-0.2))-0.02;\n\t\tfloat d3=min(max(p.x-0.05,r-0.18),length(vec2(max(p.x-0.11,0.0),r-0.18))-0.02);\n\t\tif(abs(p0.y-0.7)<0.1 && abs(p0.x)<prp.y+0.08 && p0.z>-0.9900)col=vec3(0.0);\n\t\tif(d2<d0)\n\t\t{\n\t\t\td0=d2;\n\t\t\tcol=vec3(0.0);\n\t\t}\n\t\tif(d3<d0)\n\t\t{\n\t\t\td0=d3;\n\t\t\tcol=vec3(0.75);\n\t\t}\n\t}\n\tif(dg<d0)\n\t{\n\t\tspec=0.0;\n\t\tcol=mix(vec3(0.5,0.4,0.0),vec3(0.1-g,0.3,0.1),smoothstep(0.0,0.25,d));\n\t\tcol=mix(vec3(0.2-d*0.5),col,smoothstep(0.0,0.05,d));\n\t\ta=min(d*floor(mod(a*39.1,2.0)),abs(d+0.1)-0.4);\n\t\tcol=mix(vec3(1.0),col,smoothstep(-0.40,-0.39,a));\n\t}\n\telse spec=0.5;\n\tclr+=col;\n\treturn min(dg,d0)*0.1;\n}\n\nfloat linstep(float a, float b, float t)\n{   return clamp((t-a)/(b-a),0.,1.);  }  // i got this from knighty and/or darkbeam\n\n//random seed and generator\nfloat randSeed;\nfloat randStep()   //a simple pseudo random number generator based on iq's hash\n{\treturn  (0.8+0.2*fract(sin(++randSeed)*43758.5453123));   }\n\nfloat AO(vec3 ro, vec3 rd)\n{\n\tfloat t=0.0,d=1.0,s=1.0,rCoC=0.01;\n\tro+=rd*rCoC*2.0;\n\tfor(int i=0;i<16;i++){\n\t\tfloat r=rCoC+t*0.5;//radius of cone\n\t\td=DE(ro+rd*t)+r*0.5;\n\t\ts*=linstep(-r,r,d);\n\t\tt+=abs(d)*randStep();\n\t}\n\treturn clamp(0.25+0.75*s,0.0,1.0);\n}\n\nvec3 Light(vec3 P, vec3 rd, float t, float d)\n{\n\tvec2 v=vec2(pixelSize*t*0.1,0.0);\n\tclr=vec3(0.0);\n\tvec3 N=normalize(vec3(-CE(P-v.xyy)+CE(P+v.xyy),-CE(P-v.yxy)+CE(P+v.yxy),-CE(P-v.yyx)+CE(P+v.yyx)));\n\tclr*=0.1666;\n\tfloat s=0.03;\n\tif(clr.b>0.15) s=0.8;\n//\tif(s<0.1)\n//\t  N=normalize(N+(texture2D(texture,P.xz*s).rgb-vec3(0.5))*0.2);\n\tclr*=max(0.25,dot(N,L));\n\tif(spec>0.0){\n\t\tclr=mix(clr,vec3(1.0,0.0,1.0),length(clr)*0.75*abs(dot(rd,N)));\n\t\tclr+=sunColor*pow(max(0.0,dot(reflect(rd,N),L)),specExp)*spec;\n\t}\n\treturn mix(clr*AO(P,L),vec3(0.05),clamp(d*20.0,0.0,1.0)); //apply super soft shadow/ao\n}\n\nmat3 lookat(vec3 fw,vec3 up)\n{\n\tfw=normalize(fw);vec3 rt=normalize(cross(fw,up));return mat3(rt,cross(rt,fw),fw);\n}\n\nvoid main(void)\n{\n\tpixelSize = 2.0 / resolution.y;\n\trandSeed=fract(cos((gl_FragCoord.x+gl_FragCoord.y*117.0+time*10.0)*473.7192451));\n\tL=normalize(vec3(-0.25,0.33,-0.7));\n\tfloat tim=time*0.2;\n\tPositionCars(tim);\n\ttim+=sin(time*0.4)*1.5;\n\tfloat x=cos(tim)*12.0+cos(tim*1.6)*3.0;\n\tfloat y=sin(tim)*12.0+sin(tim*1.7)*3.0;\n\tvec3 ro=vec3(x,1.5,y);\n\tvec3 cp=mix(cp2,cp3,sin(tim*1.3));\n\tvec3 rd=lookat(cp-ro,vec3(0.0,1.0,0.0))*normalize(vec3((2.0*gl_FragCoord.xy-resolution.xy)/resolution.y,12.0));\n\tvec3 col=vec3(0.05,0.1,0.2)+sunColor*(pow(max(0.0,dot(L,rd)),2.0)+clamp(-rd.y*6.0,0.0,1.0));\n\tvec3 bcol=col;\n\tfloat t=0.0, d=1.0, od=1.0;\n\tfor(int i=0;i<64;i++)\n\t{\n\t\tif(d<0.0 || t>40.0)continue;\n\t\tt+=d=DE(ro+rd*t)*0.95;\n\t}\n\tif(t<40.0)  // if we hit a surface color it\n\t\tcol=Light(ro+rd*t,rd,t,d);\n\t\n\tcol=mix(col,bcol,t*t/1600.0);\n\tgl_FragColor = vec4(clamp(1.5*col,0.0,1.0),1.0);\n}\n", "user": "5d0a1fb", "parent": null, "id": "23585.1"}