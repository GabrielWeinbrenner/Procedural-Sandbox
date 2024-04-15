//
//  Procedural_SandboxApp.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/15/24.
//

import SwiftUI

@main
struct Procedural_SandboxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
