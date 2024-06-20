import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var proceduralEntity: ProceduralEntityGeneration

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var terrainSize: Float = 100
    @State private var autoOffsetTimer: Timer?
    @State private var isOffsetting: Bool = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            settingSlider(title: "Size", value: $terrainSize, range: 0...200, step: 1)
                .onChange(of: terrainSize) { oldValue, newValue in
                    proceduralEntity.setTerrainSize(to: Int(newValue))
                }
            settingSlider(title: "Octaves", value: $proceduralEntity.octaves, range: 0...10, step: 1)
            settingSlider(title: "Persistence", value: $proceduralEntity.persistence, range: 0...1, step: 0.01)
            settingSlider(title: "Scale", value: $proceduralEntity.perlinScale, range: 0.1...100, step: 0.5)
            settingSlider(title: "Lacunarity", value: $proceduralEntity.lacunarity, range: 0...10, step: 0.1)
            settingSlider(title: "X Offset", value: $proceduralEntity.xOffset, range: -10...10, step: 0.1)
            settingSlider(title: "Y Offset", value: $proceduralEntity.yOffset, range: -10...10, step: 0.1)

            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
            Button(action: {
                isOffsetting.toggle()
                if isOffsetting {
                    startAutoOffset()
                } else {
                    stopAutoOffset()
                }
            }) {
                Text(isOffsetting ? "Stop Offsetting" : "Start Offsetting")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding()
        .onChange(of: showImmersiveSpace) { newValue in
            handleImmersiveSpaceToggle(newValue)
        }
    }
    private func startAutoOffset() {
        autoOffsetTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            proceduralEntity.xOffset += 0.1
            proceduralEntity.yOffset += 0.1
        }
    }

    private func stopAutoOffset() {
        autoOffsetTimer?.invalidate()
        autoOffsetTimer = nil
    }

    // Refactor repeated Slider code into a single function
    @ViewBuilder
    private func settingSlider(title: String, value: Binding<Float>, range: ClosedRange<Float>, step: Float) -> some View {
        VStack {
            Text(title)
            Slider(value: value, in: range, step: Float.Stride(step)) {
                Text(title)
                    .font(.title)
            } minimumValueLabel: {
                Text("\(range.lowerBound)")
            } maximumValueLabel: {
                Text("\(range.upperBound)")
            }
        }
    }
    
    // Handle immersive space changes separately
    private func handleImmersiveSpaceToggle(_ newValue: Bool) {
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

// #Preview {
//     ProceduralConfigurationView()
// }
