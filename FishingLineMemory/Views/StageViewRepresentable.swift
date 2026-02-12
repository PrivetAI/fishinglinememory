
import SwiftUI
import WebKit

struct StageViewRepresentable: UIViewRepresentable {

    let currentStage: URL
    
    @EnvironmentObject private var viewModel: StageViewModel
    
    init(_ currentStage: URL) {
        self.currentStage = currentStage
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let stageView = WKWebView(frame: .zero, configuration: viewModel.initialConfiguration())
        
        stageView.uiDelegate = context.coordinator
        stageView.navigationDelegate = context.coordinator
        stageView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        viewModel.setupStage(stageView, with: currentStage)
        
        return stageView
    }
}

//MARK: - Coordinator
extension StageViewRepresentable {
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        private let grandParent: StageViewRepresentable
        
        private var stageStepper: Int64 = 0
        
        init(_ grandParent: StageViewRepresentable) {
            self.grandParent = grandParent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
                        
            if let urlResponse = navigationResponse.response as? HTTPURLResponse {
                print("Response status code: \(urlResponse.statusCode)")
                stageStepper += urlResponse.expectedContentLength
                
                if urlResponse.statusCode < 200 || urlResponse.statusCode > 300 {
                    print("Close from status code")
                    breackCurrentStage()
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            print("Error navigation: \(error.localizedDescription)")
            searchCurrentStage()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            searchCurrentStage()
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Page load failed with error: \(error.localizedDescription)")
            searchCurrentStage()
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                if navigationAction.targetFrame == nil {
                    webView.load(URLRequest(url: url))
                    decisionHandler(.cancel)
                    return
                }
                
                if let scheme = url.scheme {
                    if (scheme != "https" && scheme != "http") || (scheme == "tg" || scheme == "telegram") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                webView.load(URLRequest(url: url))
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in completionHandler() }
            
            alertController.addAction(action)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            } else {
                completionHandler()
            }
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                if let navigationObject = object as? WKWebView {
                    DispatchQueue.main.async {
                        self.grandParent.viewModel.stageStep = navigationObject.estimatedProgress
                    }
                }
            }
        }
        
        private func searchCurrentStage() {
            if stageStepper == 0 {
                breackCurrentStage()
            } else {
                savedCurrentStageProgress()
            }
        }
        
        private func breackCurrentStage() {
            withAnimation(.spring(duration: 0.25)) {
                grandParent.viewModel.isOpenBackStage = false
                grandParent.viewModel.isOpenStageProgress = false
            }
        }
        
        private func savedCurrentStageProgress() {
            withAnimation(.spring(duration: 0.25)) {
                grandParent.viewModel.isOpenBackStage = true
                grandParent.viewModel.isOpenStageProgress = false
            }
        }
    }
}

//MARK: - updateUIView() & makeCoordinator() Methods
extension StageViewRepresentable {
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
