{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\nuniform sampler2D backbuffer;\n\nvoid main( void ) {\n    vec2 uv = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;\n    vec3 color = texture2D(backbuffer, uv).rgb;\n    gl_FragColor = vec4(clamp(color + 0.004, 0.0, 1.0), 1.0);\n}", "user": "d350157", "parent": null, "id": "46298.0"}