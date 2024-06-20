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
    
    /* 
     perlinScale: zoom level of noise
     octaves: number of noise layers
     persistance: controls amplitude decrease per octave
     lacunarity: frequency multiplier per octave
     */
    var perlinScale: Float
    var octaves: Float
    var persistance: Float
    var lacunarity: Float
    var xOffset: Float
    var yOffset: Float
    init() {
        terrainSize = 100
        perlinScale = 27
        octaves = 2
        persistance = 0.2
        lacunarity = 2
        xOffset = 0
        yOffset = 0
    }
    
    func getTerrainHeights() -> [Float] {
        var terrainHeights: [Float] = []

        let perlin = Perlin2D(seed: "World", octaves: Int(octaves), offset: (xOffset, yOffset))
//        var octaveOffsets: [(x: Float, y: Float)] = []
        var scale = perlinScale
        if scale <= 0 {
            scale = 0.0001
        }
//        var maxNoiseHeight: Float = -Float.infinity
//        var minNoiseHeight: Float = Float.infinity
        var halfWidth = terrainSize / 2
        var halfHeight = terrainSize / 2
        for y in 0..<terrainSize {
            for x in 0..<terrainSize {
                var amplitude: Float = 1
                var frequency: Float = 1
                var noiseHeight: Float = 0
                
                for i in 0..<Int(octaves) {
                    
                    let nx = Float(x-halfWidth) / perlinScale * frequency + perlin.octaveOffsets[i].x
                    let ny = Float(y-halfHeight) / perlinScale * frequency + perlin.octaveOffsets[i].y
                    
                    let perlinValue = perlin.noise(x: CGFloat(nx), y: CGFloat(ny))
                    noiseHeight += Float(perlinValue) * amplitude
                    
                    amplitude *= persistance
                    frequency *= lacunarity

                }
//                if noiseHeight > maxNoiseHeight {
//                    maxNoiseHeight = noiseHeight
//                } else if noiseHeight < minNoiseHeight {
//                    minNoiseHeight = noiseHeight
//                }
                
                terrainHeights.append(noiseHeight)
                
            }
        }


        return terrainHeights
    }
    
    mutating func setTerrainSize(to terrainSize: Int) {
        self.terrainSize = terrainSize
    }
    mutating func setPersistance(to persistance: Float) {
        self.persistance = persistance
    }
    mutating func setOctaves(to octave: Float) {
        self.octaves = octave
    }
    mutating func setPerlinScale(to scale: Float) {
        self.perlinScale = scale
    }
    mutating func setLacunarity(to lacunarity: Float) {
        self.lacunarity = lacunarity
    }
    mutating func setXOffset(to x: Float) {
        self.xOffset = x
    }
    mutating func setYOffset(to y: Float) {
        self.yOffset = y
    }


}
