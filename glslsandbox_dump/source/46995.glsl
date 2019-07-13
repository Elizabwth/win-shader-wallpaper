{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\tvec2 c = resolution.xy / 2.;\n\tvec2 p = gl_FragCoord.xy - resolution.xy * .5;\n\tfloat t = mod(time,1000.0);\n\tt *= c.x < length(p) ? 0. : pow((c.x - length(p))/length(c),1.5) * 5.;\n\tgl_FragColor = vec4( p.y*cos(t) < p.x*sin(t) ? 1 : 0 ) ;\n}", "user": "632753d", "parent": "/e#46983.1", "id": 46995}