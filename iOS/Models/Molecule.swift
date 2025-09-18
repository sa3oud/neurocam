import Foundation

struct Molecule: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let shaderFile: String
}

let molecules = [
    Molecule(name: "LSD-25",  shaderFile: "LSD-25"),
    Molecule(name: "DMT",     shaderFile: "DMT"),
    Molecule(name: "Psilo",   shaderFile: "Psilo"),
    Molecule(name: "MDMA",    shaderFile: "MDMA"),
    Molecule(name: "Ketamine",shaderFile: "Ketamine")
]
