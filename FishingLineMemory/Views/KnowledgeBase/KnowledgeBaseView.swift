import SwiftUI

struct KnowledgeBaseView: View {
    @State private var selectedArticle: Article?
    
    private let articles: [Article] = [
        Article(
            title: "When to Replace Your Line",
            icon: "clock.arrow.circlepath",
            content: """
            Knowing when to replace your fishing line is crucial for landing fish consistently.

            **Signs Your Line Needs Replacing:**

            • **Visible damage** - Nicks, abrasions, or fraying anywhere on the line
            • **Memory coils** - Line that springs into coils when slack
            • **Discolouration** - Faded or milky appearance on monofilament
            • **Reduced knot strength** - Knots breaking more easily than before
            • **Stiffness** - Line feeling brittle or less supple

            **General Guidelines by Line Type:**

            **Monofilament:**
            - Replace every 2-3 months with regular use
            - Inspect after each trip for nicks
            - UV exposure degrades it faster

            **Braided Line:**
            - Can last 6-12 months or longer
            - Replace when fibres start separating
            - Check the first 10 metres regularly

            **Fluorocarbon:**
            - Similar to mono, 3-6 months
            - More abrasion resistant but can crack
            - Check for invisible stress fractures

            **Pro Tip:** When in doubt, run the line through your fingers. Any rough spots mean it's time for a change!
            """
        ),
        Article(
            title: "Line Types Explained",
            icon: "list.bullet.circle",
            content: """
            Choosing the right line type can make a significant difference in your fishing success.

            **Monofilament**

            Pros:
            • Affordable and widely available
            • Good knot strength
            • Some stretch absorbs shock
            • Floats on water

            Cons:
            • Line memory (develops coils)
            • UV degradation over time
            • Lower sensitivity
            • Higher visibility in water

            Best for: Beginners, topwater fishing, general use

            **Braided Line**

            Pros:
            • Extremely strong for diameter
            • No stretch = high sensitivity
            • No line memory
            • Long-lasting

            Cons:
            • Highly visible in water
            • Can cut into rod guides
            • Difficult to cut without proper tools
            • More expensive

            Best for: Heavy cover, deep water, experienced anglers

            **Fluorocarbon**

            Pros:
            • Nearly invisible underwater
            • Sinks quickly
            • Abrasion resistant
            • UV resistant

            Cons:
            • Stiff and harder to manage
            • More expensive
            • Can be brittle in cold
            • Sinks (bad for topwater)

            Best for: Clear water, leader material, wary fish
            """
        ),
        Article(
            title: "Extending Line Lifespan",
            icon: "heart.circle",
            content: """
            Proper care can significantly extend the life of your fishing line and save you money.

            **Storage Tips:**

            • Store reels in a cool, dark place
            • Avoid leaving rods in hot cars
            • Keep line away from chemicals and fuels
            • Don't store near fluorescent lights

            **During Use:**

            • Avoid dragging line across rough surfaces
            • Don't let line contact engine fuel or oils
            • Rinse with fresh water after saltwater use
            • Check line frequently for damage

            **Maintenance Routine:**

            1. **After each trip:** Wipe down line with a damp cloth
            2. **Weekly:** Inspect first 15 metres for damage
            3. **Monthly:** Consider stripping off damaged sections
            4. **Seasonally:** Full line replacement if heavily used

            **Winter Fishing Special:**

            Ice fishing puts extra stress on line:
            • Cold temperatures make line brittle
            • Ice edges can nick and fray
            • Check line more frequently
            • Consider line conditioner

            **Quick Test:**

            Run line between your fingers. If you feel ANY roughness, cut that section off or replace the whole spool. One weak spot can cost you the fish of a lifetime!
            """
        )
    ]
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(articles) { article in
                        Button(action: { selectedArticle = article }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.primary.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: article.icon)
                                        .font(.system(size: 22))
                                        .foregroundColor(AppTheme.primary)
                                }
                                
                                Text(article.title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(AppTheme.textMuted)
                            }
                            .padding(16)
                            .background(AppTheme.cardBackground)
                            .cornerRadius(AppTheme.cornerRadiusMedium)
                        }
                    }
                }
                .adaptivePadding()
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Knowledge Base")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
        }
    }
}

// MARK: - Article Model

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let content: String
}

// MARK: - Article Detail

struct ArticleDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let article: Article
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.primary.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: article.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(AppTheme.primary)
                            }
                            
                            Spacer()
                        }
                        
                        Text(article.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        // Content with markdown-like formatting
                        ForEach(parseContent(article.content), id: \.self) { line in
                            if line.hasPrefix("**") && line.hasSuffix("**") {
                                Text(line.replacingOccurrences(of: "**", with: ""))
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding(.top, 8)
                            } else if line.hasPrefix("• ") {
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(AppTheme.primary)
                                    Text(line.replacingOccurrences(of: "• ", with: ""))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .font(.system(size: 15))
                            } else if !line.isEmpty {
                                Text(line)
                                    .font(.system(size: 15))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
    
    private func parseContent(_ content: String) -> [String] {
        content.components(separatedBy: "\n")
    }
}

struct KnowledgeBaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KnowledgeBaseView()
        }
    }
}
