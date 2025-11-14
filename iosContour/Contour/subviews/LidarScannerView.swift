import SwiftUI
import ARKit
import RealityKit

// 1. The SwiftUI wrapper (UIViewControllerRepresentable)
struct LidarScannerView: UIViewControllerRepresentable {
    
    // Proxy class to allow a SwiftUI button to call a UIKit function
    class ScannerProxy {
        var exportAction: (() -> URL?)?
    }

    let proxy: ScannerProxy

    func makeUIViewController(context: Context) -> LidarScannerViewController {
        let controller = LidarScannerViewController()
        controller.coordinator = context.coordinator
        
        // Link the export function from the controller to the proxy
        proxy.exportAction = controller.exportMesh
        
        return controller
    }

    func updateUIViewController(_ uiViewController: LidarScannerViewController, context: Context) {
        // No update logic needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // 2. The Coordinator handles ARSession delegate callbacks to collect mesh data
    class Coordinator: NSObject, ARSessionDelegate {
        // Dictionary to store all mesh chunks identified by ARKit
        var meshAnchors: [UUID: ARMeshAnchor] = [:]

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let meshAnchor = anchor as? ARMeshAnchor {
                    // Collect or update the mesh anchor provided by LiDAR
                    meshAnchors[meshAnchor.identifier] = meshAnchor
                }
            }
        }
    }
}

// 3. The UIKit ViewController that manages the AR Session and LiDAR
class LidarScannerViewController: UIViewController {
    
    var arView: ARView!
    var coordinator: LidarScannerView.Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the ARView
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // --- ARKit Configuration using LiDAR ---
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .mesh       // CRITICAL: Enables mesh generation from LiDAR
        config.environmentTexturing = .automatic
        config.planeDetection = [.horizontal, .vertical]

        // Show the debug mesh overlay (optional, but helpful)
        arView.debugOptions.insert(.showSceneUnderstanding)
        
        // Connect the coordinator to handle updates
        arView.session.delegate = coordinator
        arView.session.run(config)
        // ----------------------------------------
    }

    // 4. Mesh Export Logic: Combines all ARMeshAnchors into a single .OBJ file (FIXED)
    func exportMesh() -> URL? {
        guard let meshes = coordinator?.meshAnchors.values else { return nil }
        
        var obj = ""
        var totalVertexCount = 0

        // Combine geometry from all detected mesh anchors
        for mesh in meshes {
            let geometry = mesh.geometry
            let vertexCount = geometry.vertices.count
            let normalCount = geometry.normals.count

            // 1. FIX VERTICES: Use pointer access for unambiguous reading
            let vertexPointer = geometry.vertices.buffer.contents().bindMemory(to: simd_float3.self, capacity: vertexCount)
            
            // Vertices (v)
            for i in 0..<vertexCount {
                let vertex = vertexPointer[i] // Unambiguous access via pointer
                obj += "v \(vertex.x) \(vertex.y) \(vertex.z)\n"
            }

            // 2. FIX NORMALS: Use pointer access for unambiguous reading
            let normalPointer = geometry.normals.buffer.contents().bindMemory(to: simd_float3.self, capacity: normalCount)
            
            // Normals (vn)
            for i in 0..<normalCount {
                let normal = normalPointer[i] // Unambiguous access via pointer
                obj += "vn \(normal.x) \(normal.y) \(normal.z)\n"
            }
            
            // 3. FACES: (This section was previously corrected and remains correct)
            let faceCount = geometry.faces.count
            let faces = geometry.faces
            
            // Accessing the raw UInt32 buffer using a pointer
            let facePointer = faces.buffer.contents().bindMemory(to: UInt32.self, capacity: faceCount * 3)

            // ARMeshGeometry faces are always triangular (3 vertices per face)
            for i in 0..<faceCount {
                let baseIndex = i * 3
                
                // Read the three indices from the raw buffer, cast, and offset
                let index1 = Int(facePointer[baseIndex]) + totalVertexCount + 1
                let index2 = Int(facePointer[baseIndex + 1]) + totalVertexCount + 1
                let index3 = Int(facePointer[baseIndex + 2]) + totalVertexCount + 1
                
                // Format: "f v1//vn1 v2//vn2 v3//vn3"
                obj += "f \(index1)//\(index1) \(index2)//\(index2) \(index3)//\(index3)\n"
            }
            
            totalVertexCount += vertexCount
        }

        // Save the combined OBJ data to the Documents directory
        do {
            let fileURL = getDocumentsDirectory().appendingPathComponent("scan.obj")
            try obj.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Saved 3D model to: \(fileURL)")
            return fileURL
        } catch {
            print("Failed to save OBJ file: \(error)")
            return nil
        }
    }
    // Helper function to get the Documents directory URL
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
