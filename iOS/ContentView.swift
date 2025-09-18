struct ContentView: View {
    @State private var selected = molecules[0]
    @State private var pixelBuffer: CVPixelBuffer?
    @StateObject private var camera = MetalCamera(shader: loadShader(name: "LSD-25"))
    
    var body: some View {
        VStack(spacing:0) {
            MetalView(pixelBuffer: pixelBuffer, pipeline: camera)
                .onAppear { camera.onPixelBuffer = { pixelBuffer = $0 } }
                .ignoresSafeArea()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(molecules) { m in
                        Text(m.name)
                            .font(.headline)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(selected.id == m.id ? Color.purple : Color.gray.opacity(0.3))
                            .cornerRadius(12)
                            .onTapGesture { switchMolecule(m) }
                    }
                }.padding()
            }.frame(height: 70)
        }
    }
    
    func switchMolecule(_ m: Molecule) {
        selected = m
        camera.reloadShader(loadShader(name: m.shaderFile))
    }
}

func loadShader(name: String) -> String {
    let url = Bundle.main.url(forResource: name, withExtension: "frag")!
    return try! String(contentsOf: url)
}
