import SwiftUI

struct SettingsView: View {
    @AppStorage("diameterUnit") private var diameterUnit = "mm"
    @AppStorage("strengthUnit") private var strengthUnit = "lb"
    @AppStorage("lengthUnit") private var lengthUnit = "metres"
    @AppStorage("replacementMode") private var replacementMode = "normal"
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Units section
                        unitsSection
                        
                        // Replacement mode
                        replacementSection
                        
                        // Knowledge base link
                        knowledgeSection
                        
                        // About
                        aboutSection
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
    }
    
    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Units")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                settingRow("Diameter") {
                    Picker("", selection: $diameterUnit) {
                        Text("mm").tag("mm")
                        Text("inches").tag("inches")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 140)
                }
                
                Divider().background(AppTheme.background)
                
                settingRow("Strength") {
                    Picker("", selection: $strengthUnit) {
                        Text("lb").tag("lb")
                        Text("kg").tag("kg")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 140)
                }
                
                Divider().background(AppTheme.background)
                
                settingRow("Length") {
                    Picker("", selection: $lengthUnit) {
                        Text("metres").tag("metres")
                        Text("yards").tag("yards")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 140)
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var replacementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Replacement Recommendations")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                ForEach(Array(["conservative", "normal", "economical"].enumerated()), id: \.offset) { index, mode in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    Button(action: { replacementMode = mode }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(mode.capitalized)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Text(descriptionForMode(mode))
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textMuted)
                            }
                            
                            Spacer()
                            
                            if replacementMode == mode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.primary)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(AppTheme.textMuted)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var knowledgeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Knowledge Base")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            NavigationLink(destination: KnowledgeBaseView()) {
                HStack {
                    Image(systemName: "book.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppTheme.primary)
                        .frame(width: 32)
                    
                    Text("Fishing Line Guide")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textPrimary)
                    
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
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Version")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(16)
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private func settingRow<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            content()
        }
        .padding(16)
    }
    
    private func descriptionForMode(_ mode: String) -> String {
        switch mode {
        case "conservative":
            return "Replace more often for best performance"
        case "normal":
            return "Balanced approach (recommended)"
        case "economical":
            return "Maximise line lifespan"
        default:
            return ""
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
