import AVFoundation
import MetalKit
import SwiftUI

final class MetalCamera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private let device = MTLCreateSystemDefaultDevice()!
    private var commandQueue: MTLCommandQueue!
    private var renderPipeline: MTLRenderPipelineState!
    private var textureCache: CVMetalTextureCache!
    private let shader: String
    
    var onPixelBuffer: ((CVPixelBuffer) -> Void)?
    
    init(shader: String) {
        self.shader = shader
        super.init()
        commandQueue = device.makeCommandQueue()
        makePipeline()
        setupCamera()
        session.startRunning()
    }
    
    private func makePipeline() {
        let library = try! device.makeLibrary(source: shader, options: nil)
        let vertex = library.makeFunction(name: "vertexPass")!
        let fragment = library.makeFunction(name: "fragmentPass")!
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertex
        descriptor.fragmentFunction = fragment
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipeline = try! device.makeRenderPipelineState(descriptor: descriptor)
    }
    
    private func setupCamera() {
        session.sessionPreset = .hd1920x1080
        guard let cam = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: cam) else { return }
        session.addInput(input)
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera"))
        session.addOutput(output)
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let px = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        onPixelBuffer?(px)
    }
}
