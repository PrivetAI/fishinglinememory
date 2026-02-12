import SwiftUI

@main
struct FishingLineMemoryApp: App {
    var body: some Scene {
        WindowGroup {
            StageResultView()
                .preferredColorScheme(.dark)
        }
    }
}
