//
//  ProceduralConfigurationView.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/16/24.
//

import SwiftUI

struct ProceduralConfigurationView: View {
    @EnvironmentObject var proceduralEntity: ProceduralEntityGeneration
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var terrainSize: Double = 100.0

    var body: some View {
        VStack {
            Slider(value: $terrainSize, in: 0.0...500, step: 1.0) {
                Text("Terrain Size")
                    .font(.title)
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("500")
            } onEditingChanged: { isChanged in
                proceduralEntity.setTerrainSize(to: Int(terrainSize))
            }
            Slider(value: $proceduralEntity.octaves, in: 0.0...50, step: 1.0) {
                Text("Octaves")
                    .font(.title)
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("50")
            }
            Slider(value: $proceduralEntity.persistence, in: 1.0...2, step: 0.01) {
                Text("Persistance")
                    .font(.title)
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("2")
            }
            Slider(value: $proceduralEntity.perlinScale, in: 1.0...1000, step: 1) {
                Text("Persistance")
                    .font(.title)
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("2")
            }
            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

//#Preview {
//    ProceduralConfigurationView()
//}
