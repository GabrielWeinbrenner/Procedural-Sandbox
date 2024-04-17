//
//  ProceduralGeneration.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/16/24.
//

import Foundation

struct ProceduralGeneration {
    // in centimeters
    var terrainSize: Int
    var persistance: Double
    var octaves: Int
    var perlinScale: Float

    func getTerrainHeights() -> [Float] {
        var terrainHeights: [Float] = []

        let perlin = Perlin2D(seed: "World")
        for y in 0..<terrainSize {
            for x in 0..<terrainSize {
                let nx = Float(x) / perlinScale
                let ny = Float(y) / perlinScale
                
//                let perlinValue = perlin.noise(x: CGFloat(nx), y: CGFloat(ny))
                let perlinValue = perlin.octaveNoise(x: CGFloat(nx), y: CGFloat(ny), octaves: octaves, persistence: persistance )

                terrainHeights.append(Float(perlinValue))
                
            }
        }

        return terrainHeights
    }
    
    mutating func setTerrainSize(to terrainSize: Int) {
        self.terrainSize = terrainSize
    }
    mutating func setPersistance(to persistance: Double) {
        self.persistance = persistance
    }
    mutating func setOctaves(to octave: Int) {
        self.octaves = octave
    }
    mutating func setPerlinScale(to scale: Float) {
        self.perlinScale = scale
    }


    init() {
        terrainSize = 100
        persistance = 0.25
        octaves = 2
        perlinScale = 50
    }
}
