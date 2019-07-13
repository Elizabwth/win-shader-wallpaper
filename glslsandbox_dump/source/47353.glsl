{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 position = ( 2. * gl_FragCoord.xy - resolution.xy ) / resolution.y;\n\n\t\t\n\tfloat color = 0.0;\n\t\t\n\tvec2 uv = position;\n\tuv = fract(uv)-.5;\n\tcolor += (0.01 / length(uv));\n\t\n\tgl_FragColor = vec4( vec3(color), 1.0 );\n\n}", "user": "8dacf50", "parent": "/e#47352.0", "id": 47353}