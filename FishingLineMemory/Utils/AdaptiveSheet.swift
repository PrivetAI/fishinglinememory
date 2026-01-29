import SwiftUI

// View modifier to present full screen on iPad
struct FullScreenModifier: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> AnyView
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content.fullScreenCover(isPresented: $isPresented) {
                self.content()
            }
        } else {
            content.sheet(isPresented: $isPresented) {
                self.content()
            }
        }
    }
}

struct FullScreenItemModifier<Item: Identifiable>: ViewModifier {
    @Binding var item: Item?
    let content: (Item) -> AnyView
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content.fullScreenCover(item: $item) { item in
                self.content(item)
            }
        } else {
            content.sheet(item: $item) { item in
                self.content(item)
            }
        }
    }
}

extension View {
    func adaptiveSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.fullScreenCover(isPresented: isPresented) {
                    content()
                }
            } else {
                self.sheet(isPresented: isPresented) {
                    content()
                }
            }
        }
    }
    
    func adaptiveSheet<Item: Identifiable, Content: View>(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.fullScreenCover(item: item) { item in
                    content(item)
                }
            } else {
                self.sheet(item: item) { item in
                    content(item)
                }
            }
        }
    }
}
