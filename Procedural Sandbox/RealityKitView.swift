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
    @EnvironmentObject var proceduralEntity: ProceduralEntityGeneration
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
            }))
        .onAppear() {
            // Appear happens before realitykit scene controller init
        }
    }
}
