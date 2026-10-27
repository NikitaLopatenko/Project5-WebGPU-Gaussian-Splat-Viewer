struct CameraUniforms {
    view: mat4x4<f32>,
    view_inv: mat4x4<f32>,
    proj: mat4x4<f32>,
    proj_inv: mat4x4<f32>,
    viewport: vec2<f32>,
    focal: vec2<f32>
};

struct Gaussian {
    pos_opacity: array<u32,2>,
    rot: array<u32,2>,
    scale: array<u32,2>
}

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    //TODO: information passed from vertex shader to fragment shader
};

struct Splat {
    //TODO: information defined in preprocess compute shader
    center: vec2<f32>,
    half_size_pixels: vec2<f32>,
    conic: vec3<f32>,
    opacity: f32,
    color: vec4<f32>,
};


@group(0) @binding(0)
var<uniform> camera: CameraUniforms;

@group(1) @binding(0)
var<storage, read> splats: array<Splat>;



@vertex
fn vs_main(
    @builtin(vertex_index) vertex_index: u32,
    @builtin(instance_index) instance_index: u32,
) -> VertexOutput {

    //TODO: reconstruct 2D quad based on information from splat, pass 

    let splat = splats[instance_index];

    // two triangles around the center
    var corner = array<vec2<f32>, 6>(
        vec2<f32>(-1.0, -1.0),
        vec2<f32>( 1.0, -1.0),
        vec2<f32>(-1.0,  1.0),
        vec2<f32>(-1.0,  1.0),
        vec2<f32>( 1.0, -1.0),
        vec2<f32>( 1.0,  1.0),
    );

    // pixel radius to NDC size
    let half_size_ndc = splat.half_size_pixels * 2.0 / camera.viewport; //multiply by 2 because it is the size of NDC

    var out: VertexOutput;

    out.position = vec4<f32>(
        splat.center + corner[vertex_index] * half_size_ndc,
        0.0,
        1.0
    );

    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.);
}