
import SwiftUI

struct StageResultView: View {
    
    @StateObject private var viewModel: StageViewModel = .init()
    
    var body: some View {
        ZStack {
            if viewModel.isOpenBackStage {
                if let currentStage = viewModel.gettingStage {
                    StageView(currentStage)
                } else {
                    ContentView()
                }
            } else {
                ContentView()
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.mainStage()
        }
    }
}
