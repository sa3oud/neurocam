import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var pixelBuffer: CVPixelBuffer?
    private let camera = MetalCamera(shader: lsdShader)
    
    var body: some View {
        MetalView(pixelBuffer: pixelBuffer ?? nil, pipeline: camera)
            .onAppear { camera.onPixelBuffer = { self.pixelBuffer = $0 } }
            .ignoresSafeArea()
    }
}
