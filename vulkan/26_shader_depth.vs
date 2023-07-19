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

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoord;

void main() {
    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 1.0);
    fragColor = inColor;
    fragTexCoord = inTexCoord;
}
</code></pre>
    </body>
</html>