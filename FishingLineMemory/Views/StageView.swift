
import SwiftUI

struct StageView: View {
    
    let currentStage: URL

    @EnvironmentObject private var viewModel: StageViewModel
    
    init(_ currentStage: URL) {
        self.currentStage = currentStage
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.954)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                StageViewRepresentable(currentStage)
                
                if viewModel.stageStep < 1 {
                    ProgressView(value: viewModel.stageStep)
                        .progressViewStyle(.linear)
                        .tint(.orange.opacity(0.86))
                }
            }
        }
        .statusBarHidden()
    }
}
