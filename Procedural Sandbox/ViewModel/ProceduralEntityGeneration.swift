//
//  ProceduralEntityGeneration.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/16/24.
//

import Foundation
import RealityKit

class ProceduralEntityGeneration: ObservableObject {
    @Published private var proceduralGenerationEntity: Entity = Entity()
    @Published var octaves: Double = 2 {
        didSet {
            proceduralGeneration.setOctaves(to: Int(octaves))
        }
    }
    @Published var persistence: Double = 0.25 {
        didSet {
            proceduralGeneration.setPersistance(to: persistence)
        }
    }
    @Published var perlinScale: Float = 50 {
        didSet {
            proceduralGeneration.setPerlinScale(to: perlinScale)
        }
    }

    @Published private var proceduralGeneration: ProceduralGeneration {
        didSet {
            updateTerrainEntity()
        }
    }
    private var landscapeMaterial: ShaderGraphMaterial? = nil {
        didSet {
            updateTerrainEntity()
        }
    }
    init() {
        self.proceduralGeneration = ProceduralGeneration()
        updateTerrainEntity()

    }
    
    func getTerrainEntity() -> Entity{
       return proceduralGenerationEntity
    }
    
    func setTerrainSize(to terrainSize: Int) {
        proceduralGeneration.setTerrainSize(to: terrainSize)
    }
    
    func setTerrainMaterial(to material: ShaderGraphMaterial) {
        self.landscapeMaterial = material
    }
    
    private func updateTerrainEntity() {
        proceduralGenerationEntity.name = "terrain_entity"
        let terrainSize = proceduralGeneration.terrainSize
        
        let terrainHeights = proceduralGeneration.getTerrainHeights()
        
        let mesh = generateTerrain(width: terrainSize, height: terrainSize, terrainHeights: terrainHeights)
        if let material = landscapeMaterial {
            proceduralGenerationEntity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
        } else {
            proceduralGenerationEntity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [UnlitMaterial(color: .brown)])

        }
    }
    
    private func generateTerrain(width: Int, height: Int, terrainHeights: [Float], scale: Float = 0.01) -> MeshResource {
        var vertices: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var indices: [UInt32] = []

        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                let position = SIMD3<Float>(Float(x) * scale, terrainHeights[index], Float(y) * scale)
                vertices.append(position)
                normals.append(SIMD3<Float>(0, 1, 0))
            }
        }
                               
        for y in 0..<(height - 1) {
            for x in 0..<(width - 1) {
                let topLeft = UInt32(y * width + x)
                let topRight = UInt32(y * width + x + 1)
                let bottomLeft = UInt32((y + 1) * width + x)
                let bottomRight = UInt32((y + 1) * width + x + 1)
                
                indices.append(topLeft)
                indices.append(bottomLeft)
                indices.append(topRight)
                
                indices.append(topRight)
                indices.append(bottomLeft)
                indices.append(bottomRight)
            }
        }

        var contents = MeshResource.Contents()
        
        var part = MeshResource.Part(id: "part", materialIndex: 0)
        part.triangleIndices = MeshBuffer(indices)
        part.positions = MeshBuffer(vertices)
        part.normals = MeshBuffer(normals)
        let model = MeshResource.Model(id: "main", parts: [part])
        
        contents.models = [model]
        contents.instances = [.init(id: "instance", model: "main")]
        
        if let meshResource = try? MeshResource.generate(from: contents) {
            return meshResource
        }
        return MeshResource.generateBox(size: 0.2)
    }


    
}
