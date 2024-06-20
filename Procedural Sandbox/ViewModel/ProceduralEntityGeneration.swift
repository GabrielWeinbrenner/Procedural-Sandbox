//
//  ProceduralEntityGeneration.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/16/24.
//

import Foundation
import RealityKit

class ProceduralEntityGeneration: ObservableObject {
    private var updateDebounceTimer: Timer?
    
    private func debounceUpdate() {
        updateDebounceTimer?.invalidate()
        updateDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: false) { [weak self] _ in
            self?.updateTerrainEntity()
        }
    }
    
    @Published private var proceduralGenerationEntity: Entity = Entity()
    @Published var octaves: Float {
        didSet {
            proceduralGeneration.setOctaves(to: octaves)
        }
    }
    @Published var persistence: Float {
        didSet {
            proceduralGeneration.setPersistance(to: persistence)
        }
    }
    @Published var perlinScale: Float {
        didSet {
            proceduralGeneration.setPerlinScale(to: perlinScale)
        }
    }
    @Published var lacunarity: Float {
        didSet {
            proceduralGeneration.setLacunarity(to: lacunarity)
        }
    }
    
    @Published var xOffset: Float {
        didSet {
            proceduralGeneration.setXOffset(to: xOffset)
        }
    }
    @Published var yOffset: Float {
        didSet {
            proceduralGeneration.setYOffset(to: yOffset)
        }
    }

    @Published private var proceduralGeneration: ProceduralGeneration {
        didSet {
            debounceUpdate()
        }
    }
    private var landscapeMaterial: ShaderGraphMaterial? = nil {
        didSet {
            updateTerrainEntity()
        }
    }
    init() {
        let newProceduralGeneration = ProceduralGeneration()
        self.proceduralGeneration = newProceduralGeneration
        
        self.persistence = newProceduralGeneration.persistance
        self.perlinScale = newProceduralGeneration.perlinScale
        self.lacunarity = newProceduralGeneration.lacunarity
        self.octaves = newProceduralGeneration.octaves
        self.yOffset = newProceduralGeneration.xOffset
        self.xOffset = newProceduralGeneration.yOffset
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
            let container: ShapeResource = .generateConvex(from: mesh)
            
            proceduralGenerationEntity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
            proceduralGenerationEntity.components[CollisionComponent.self] = CollisionComponent(shapes: [container])
            
            proceduralGenerationEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
            
            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
            proceduralGenerationEntity.components.set(PhysicsBodyComponent(shapes: [container] ,
                                                       mass: 0.0,
                                                       material: material,
                                                       mode: .dynamic))

        } else {
            proceduralGenerationEntity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [UnlitMaterial(color: .brown)])
            proceduralGenerationEntity.components[CollisionComponent.self] = CollisionComponent(shapes: [.generateBox(size: .init(repeating: Float(terrainSize/100)))])

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
                normals.append(SIMD3<Float>(1, 1, 1))
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
