import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    let pixelBuffer: CVPixelBuffer
    let pipeline: MetalCamera
    
    func makeUIView(context: Context) -> MTKView {
        let v = MTKView()
        v.device = pipeline.device
        v.delegate = context.coordinator
        v.enableSetNeedsDisplay = true
        return v
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.pixelBuffer = pixelBuffer
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var pixelBuffer: CVPixelBuffer?
        
        init(_ parent: MetalView) { self.parent = parent }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            guard let buffer = pixelBuffer,
                  let texture = buffer.metalTexture(plane: 0, device: view.device!),
                  let drawable = view.currentDrawable,
                  let rpd = view.currentRenderPassDescriptor else { return }
            
            let cmd = parent.pipeline.commandQueue.makeCommandBuffer()!
            let encoder = cmd.makeRenderCommandEncoder(descriptor: rpd)!
            encoder.setRenderPipelineState(parent.pipeline.renderPipeline)
            encoder.setFragmentTexture(texture, index: 0)
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            encoder.endEncoding()
            cmd.present(drawable)
            cmd.commit()
        }
    }
}
