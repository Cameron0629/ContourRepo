// ModelView.swift

import SwiftUI
import SceneKit // 1. Import SceneKit to use SceneView

/// The destination view for displaying the user's 3D model or model list.
struct ModelView: View {
    
    // 2. RECEIVE: The binding for the model URL
    @Binding var modelURL: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your 3D Model")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            // 3. CHECK: Display the 3D model if the URL exists
            if let url = modelURL {
                
                // SceneView to load and display the 3D model
                SceneView(
                    scene: loadScene(from: url), // Helper function loads the .obj
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
                .frame(maxWidth: .infinity, maxHeight: 400)
                .cornerRadius(15)
                .padding(.horizontal)
                
                Text("Your saved .obj model. Pinch to zoom, drag to rotate.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            
            // 4. Fallback to the Placeholder
            } else {
                VStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .cornerRadius(15)
                        .overlay(
                            VStack {
                                Image(systemName: "cube.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.secondary)
                                Text("3D Model Viewer Placeholder")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        )
                    
                    Text("Take a scan from the Profile page to see your model here.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("3D Model")
    }
    
    // 5. Helper function to load the SCNScene from a URL
    private func loadScene(from url: URL) -> SCNScene? {
        do {
            // SCNScene can load .obj files directly
            let scene = try SCNScene(url: url, options: nil)
            return scene
        } catch {
            print("Failed to load SCNScene from URL: \(error)")
            return nil
        }
    }
}

struct ModelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Update preview to work with the binding
            ModelView(modelURL: .constant(nil))
        }
    }
}
