{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 p=(gl_FragCoord.xy/resolution.xy-0.5)*resolution.xy/resolution.y*10.0;\n\tfloat d=length(p);\n\tfloat r=acos(p.x/d)/3.141592654;\n\tr=p.y<0.0?1.0-r:r;\n\tfloat c=sin(d*1.0+r*6.28-time*7.0)*0.25+0.5;\n\tfloat c1=sin(d*10.0+r*6.28-time*7.0)*0.75+0.5;\n\tgl_FragColor = vec4( c*c1 );\n\n}", "user": "54b9c3", "parent": "/e#25838.0", "id": "25842.0"}