//
//  Procedural_SandboxApp.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/15/24.
//

import SwiftUI

@main
struct Procedural_SandboxApp: App {
    @StateObject var proceduralEntity = ProceduralEntityGeneration()
    var body: some Scene {
        WindowGroup {
            ProceduralConfigurationView()
                .environmentObject(proceduralEntity)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            RealityKitView()
                .environmentObject(proceduralEntity)
        }
    }
}
