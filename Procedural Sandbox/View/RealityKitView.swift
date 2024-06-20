//
//  ImmersiveView.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/15/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RealityKitView: View {
    typealias CGOfsset = CGSize

    @EnvironmentObject var proceduralEntity: ProceduralEntityGeneration
    

    @State private var pan: CGOfsset = .zero
    @GestureState private var gesturePan: CGOfsset = .zero
    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let xOffsetChange = Float(value.translation3D.x / 10000)
                let yOffsetChange = Float(value.translation3D.y / 10000)
                proceduralEntity.xOffset += xOffsetChange
                proceduralEntity.yOffset += yOffsetChange
            }
            .onEnded { value in
                pan += value.translation
                proceduralEntity.xOffset += Float(value.translation3D.x / 10000)
                proceduralEntity.yOffset += Float(value.translation3D.y / 10000)
            }
    }

    var rootEntity = Entity()
    var body: some View {
        RealityView { content, attachments in
            content.add(rootEntity)
            Task {
                do {
                    let texture = try await ShaderGraphMaterial(named: "/TerrainShader", from: "TerrainShader", in: realityKitContentBundle)
                    proceduralEntity.setTerrainMaterial(to: texture)
                } catch {
                    print("PuzzleMaterial load failed: \(error)")
                }
            }

            rootEntity.addChild(proceduralEntity.getTerrainEntity())
        } update: { content, attachments in
            
        } placeholder: {
            ProgressView()
        } attachments: {
            let _ = print("--attachments")
            Attachment(id: "emptyAttachment") {
                
            }
        }
        .gesture(SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded({ targetValue in
                print(targetValue)
            }))
        .gesture(panGesture
            .targetedToEntity(proceduralEntity.getTerrainEntity()))
        .onAppear() {
            // Appear happens before realitykit scene controller init
        }
    }
}
