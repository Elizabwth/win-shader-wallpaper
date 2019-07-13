{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\nconst vec3 white = vec3(.5,.5,.7);\nconst vec3 black = vec3(.4,.4,.6);\nconst vec3 line_color = vec3(.3,.3,.5);\nconst float sz = 20.;\nuniform float time;\n\nvoid main() { // Houndstooth\n  vec2 p = gl_FragCoord.xy;\n  float osc = clamp(sin(time*2.)*5., -1., 1.) / 2. + .5;\n  bool is_border = mod(p.x, sz) < 1. || mod(p.y, sz) < 1.;\n\n  vec3 weave1 = mod(p.x, 2.*sz) < sz ? black : white;\n  vec3 weave2 = mod(p.y, 2.*sz) < sz ? black : white;\n  vec3 color  = mod(p.x+p.y, sz) < sz/2. ? weave1 : weave2;\n  gl_FragColor = vec4(mix(line_color, color, is_border ? osc : 1.), 1.);\n}", "user": "955c5e6", "parent": "/e#47437.2", "id": 47438}