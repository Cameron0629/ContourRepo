// CreateScanView.swift

import SwiftUI
import UIKit
import ARKit // Make sure this is imported

/// The view where the user initiates a new 3D scan using the device camera.
struct CreateScanView: View {
    
    // 1. RECEIVE: The binding for the model URL
    @Binding var modelURL: URL?
    
    // 2. PROXY: Create the proxy object to communicate with the AR ViewController
    private let scannerProxy = LidarScannerView.ScannerProxy()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        // 3. ZStack to overlay the button on the scanner view
        ZStack(alignment: .bottom) {
            
            // 4. HOST: The LidarScannerView
            LidarScannerView(proxy: scannerProxy)
                .edgesIgnoringSafeArea(.all)
            
            // 5. Button to stop the scan and save the file
            Button {
                // Call the export function via the proxy
                if let url = scannerProxy.exportAction?() {
                    // Set the binding with the saved file URL
                    self.modelURL = url
                    // Dismiss this view and return to ProfileView
                    dismiss()
                } else {
                    print("Error: Could not export 3D model.")
                    // TODO: Show a user-friendly alert here
                }
            } label: {
                Text("Stop & Save 3D Model")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Scanning...")
        .navigationBarBackButtonHidden(true) // Hide the back button while scanning
    }
}

struct CreateScanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Update the preview to provide a constant binding
            CreateScanView(modelURL: .constant(nil))
        }
    }
}
