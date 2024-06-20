# 🌍 Procedural Sandbox 🌍

Welcome to Procedural Sandbox, an innovative project developed in Swift using RealityKit. This application features dynamic procedural generation of terrains, allowing you to explore and interact with an ever-changing world. Perfect for creating immersive environments and experimenting with procedural content.

## Features ✨

- 🏞️ Real-time procedural generation of terrains.
- 🛠️ Adjustable parameters for octaves, persistence, Perlin scale, lacunarity, and offsets.
- 📈 Dynamic updates with smooth transitions using debounce mechanisms.
- 🎨 Customizable materials for terrain visualization.
- 🕹️ Interactive environment with support for panning and gestures.

## Technologies Used 🛠️

- **Swift**: The primary programming language used for development.
- **RealityKit**: Used for rendering and interacting with 3D content.
- **Foundation**: Provides essential data types and collections.
- **RealityKitContent**: Manages content for RealityKit scenes.

## File Descriptions 📄

### `ProceduralEntityGeneration.swift`

This file contains the `ProceduralEntityGeneration` class, which handles the procedural generation of terrain entities. It includes methods for updating terrain parameters, generating mesh resources, and applying materials.

### `ImmersiveView.swift`

This file defines the `RealityKitView` and `ConfigurationView` structures, which provide the user interface for interacting with the procedural terrain. It includes gesture handling for panning and immersive space toggling.

### `Perlin2D.swift`

This file includes the `Perlin2D` class, which implements Perlin noise generation. It provides methods for generating noise values and creating height maps for terrain generation.
