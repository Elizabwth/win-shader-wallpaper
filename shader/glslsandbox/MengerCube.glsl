{"code": "// See http://www.iquilezles.org/articles/menger/menger.htm for the \n// full explanation of how this was done\n\n// @rotwang @mod* pos, aspect, color\n// bug: can't find out why its clipping\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\n\nfloat maxcomp(in vec3 p ) { return max(p.x,max(p.y,p.z));}\nfloat sdBox( vec3 p, vec3 b )\n{\n  vec3  di = abs(p) - b;\n  float mc = maxcomp(di);\n  return min(mc,length(max(di,0.0)));\n}\n\nvec4 mapper( in vec3 p )\n{\n   float d = sdBox(p,vec3(1.0));\n   vec4 res = vec4( d, 1.0, 0.0, 0.0 );\n\n   float s = 1.0;\n   for( int m=0; m<3; m++ ) \n   {\n      vec3 a = mod( p*s, 2.0 )-1.0;\n      s *= 3.0;\n      vec3 r = abs(1.0 - 3.0*abs(a));\n\n      float da = max(r.x,r.y);\n      float db = max(r.y,r.z);\n      float dc = max(r.z,r.x);\n      float c = (min(da,min(db,dc))-1.0)/s;\n\n      if( c>d )\n      {\n          d = c;\n          res = vec4( d, 0.1*da*db*dc, (1.0+float(m))/4.0, 0.0 );\n       }\n   }\n   return res;\n}\n\n\n// GLSL ES doesn't seem to like loops with conditional break/return...\n#if 0\nvec4 intersect( in vec3 ro, in vec3 rd )\n{\n    float t = 0.0;\n    for(int i=0;i<64;i++)\n    {\n        vec4 h = map(ro + rd*t);\n        if( h.x<0.002 ) \n            return vec4(t,h.yzw);\n        t += h;\n    }\n    return vec4(-1.0);\n}\n#else\nvec4 intersect( in vec3 ro, in vec3 rd )\n{\n    float t = 0.0;\n    vec4 res = vec4(-1.0);\n    for(int i=0;i<64;i++)\n    {\n        vec4 h = mapper(ro + rd*t);\n        if( h.x<0.002 ) \n        {\n            if( res.x<0.0 ) res = vec4(t,h.yzw);\n        }\n\n        t += h.x;\n    }\n    return res;\n}\n#endif\n\nvec3 calcNormal(in vec3 pos)\n{\n    vec3  eps = vec3(.001,0.0,0.0);\n    vec3 nor;\n    nor.x = mapper(pos+eps.xyy).x - mapper(pos-eps.xyy).x;\n    nor.y = mapper(pos+eps.yxy).x - mapper(pos-eps.yxy).x;\n    nor.z = mapper(pos+eps.yyx).x - mapper(pos-eps.yyx).x;\n    return normalize(nor);\n}\n\nvoid main(void)\n{\n\t\n\tfloat aspect = resolution.x / resolution.y;\n\tvec2 unipos = (gl_FragCoord.xy / resolution.xy);\n\tvec2 p = unipos*2.0-1.0;\n\tp.x *= aspect;\n\t\n \t\n\t\n    // light\n    vec3 light = normalize(vec3(1.0,0.8,-0.6));\n\n    float ctime = time;\n    // camera\n    vec3 ro = 1.1*vec3(2.5*cos(0.25*ctime),1.5*cos(ctime*.23),2.5*sin(0.25*ctime));\n    vec3 ww = normalize(vec3(0.0) - ro);\n    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    vec3 vv = normalize(cross(ww,uu));\n    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );\n\n    vec3 col = vec3(0.0);\n    vec4 tmat = intersect(ro,rd);\n    if( tmat.x>0.0 )\n    {\n        vec3 pos = ro + tmat.x*rd;\n        vec3 nor = calcNormal(pos);\n\n        float dif1 = max(0.2 + 0.8*dot(nor,light),0.0);\n        float dif2 = max(0.2 + 0.8*dot(nor,vec3(-light.x,light.y,-light.z)),0.0);\n\n        // shadow\n\t    \n        float ldis = 4.0;\n        vec4 shadow = intersect( pos + light*ldis, -light );\n        if( shadow.x>0.0 && shadow.x<(ldis-0.01) ) dif1=0.0;\n\n\t    \n        float ao = tmat.y;\n        col  = 1.0*ao*vec3(0.2,0.2,0.2);\n        col += 2.0*(0.5+0.5*ao)*dif1*vec3(1.0,0.97,0.85);\n        col += 0.2*(0.5+0.5*ao)*dif2*vec3(1.0,0.97,0.85);\n        col += 1.0*(0.5+0.5*ao)*(0.5+0.5*nor.y)*vec3(0.1,0.15,0.2);\n\n        // gamma lighting\n        col = col*0.5+0.5*sqrt(col)*1.2;\n\n        vec3 matcol = vec3(\n            0.2+0.8*cos(5.0+6.2831*tmat.z),\n            0.3+0.7*cos(5.4+6.2831*tmat.z),\n            0.5+0.5*cos(5.4+6.2831*tmat.z) );\n        col *= matcol;\n        col *= 1.5*exp(-0.1*tmat.x);\n    }\n\n\n    gl_FragColor = vec4(col,1.0);\n}", "user": "38db6be", "parent": null, "id": "2985.1"}