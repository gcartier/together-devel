<html>
    <head>
        <link href="/themes/vulkan/css/theme.min.css" rel="stylesheet">
        <link href="/themes/vulkan/css/theme-blue.min.css" rel="stylesheet">
    </head>
    <body style="background: #343131">
        <script src="/themes/vulkan/js/highlight.pack.js"></script>
        <script>hljs.initHighlightingOnLoad();</script>
        <pre class="glsl" style="margin: 0; padding-left: 10px"><code>#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(binding = 1) uniform sampler2D texSampler;

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;

layout(location = 0) out vec4 outColor;

void main() {
    outColor = texture(texSampler, fragTexCoord);
}</code></pre>
    </body>
</html>