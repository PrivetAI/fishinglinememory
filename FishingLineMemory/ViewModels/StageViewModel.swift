
import SwiftUI
import Combine
import WebKit

final class StageViewModel: ObservableObject {
    
    @Published var gettingStage: URL? = nil
    @Published var stageStep: Double = 0.25
    
    @AppStorage("isOpenBackStageKey") var isOpenBackStage: Bool = false
    @AppStorage("isOpenStageProgressKey") var isOpenStageProgress = true
    
    private let network: NetworkDelegate = NetworkManager.shared
        
    func mainStage() {
        if isOpenStageProgress {
            stageCounter()
        } else {
            if isOpenBackStage {
                searchFromStages()
            } else {
                brokenStage()
            }
        }
    }
    
    func setupStage(_ view: WKWebView, with document: URL) {
        
        view.backgroundColor = .black
        view.scrollView.isScrollEnabled = true
        view.allowsBackForwardNavigationGestures = true
        
        view.evaluateJavaScript("navigator.userAgent") { result, error in
            guard let head = result as? String else {
                print("Error patched user agent: \(error?.localizedDescription ?? "no error description")")
                return
            }
            
            let reference = "Version/16.2"
            var newHead = head
            
            if !newHead.contains("Version/") {
                if let rangePosition = newHead.range(of: "like Gecko)")?.upperBound {
                    newHead.insert(contentsOf: " " + reference, at: rangePosition)
                } else if let position = newHead.range(of: "Mobile/")?.lowerBound {
                    newHead.insert(contentsOf: reference + " ", at: position)
                }
            }
            
            view.customUserAgent = newHead
        }
        
        view.load(URLRequest(url: document))
    }
    
    func initialConfiguration() -> WKWebViewConfiguration {
        let c = WKWebViewConfiguration()
        
        c.mediaTypesRequiringUserActionForPlayback = []
        c.allowsInlineMediaPlayback = true
        c.defaultWebpagePreferences.allowsContentJavaScript = true
        c.preferences.javaScriptCanOpenWindowsAutomatically = true
        c.websiteDataStore = WKWebsiteDataStore.default()
        
        return c
    }
}

//MARK: - Private Methods
extension StageViewModel {
    private func stageCounter() {
        Task { @MainActor in
            do {
                let response = try await network.fetchData()
                
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    searchFromStages()
                } else {
                    brokenStage()
                }
            } catch {
                print("Connection Error: \(error.localizedDescription)")
                brokenStage()
            }
        }
    }
    
    private func searchFromStages() {
        if let brain = network.origin {
            successStage(brain)
        } else {
            brokenStage()
        }
    }
    
    private func successStage(_ builderBrain: URL) {
        withAnimation(.spring) {
            gettingStage = builderBrain
            isOpenBackStage = true
            isOpenStageProgress = false
        }
    }
    
    private func brokenStage() {
        withAnimation(.spring) {
            isOpenBackStage = false
            isOpenStageProgress = false
        }
    }
}
