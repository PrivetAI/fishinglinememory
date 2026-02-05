import SwiftUI

struct SpoolCalculatorView: View {
    @AppStorage("diameterUnit") private var diameterUnit = "mm"
    @AppStorage("lengthUnit") private var lengthUnit = "metres"
    
    // Spool dimensions
    @State private var spoolOuterDiameter: String = "45"
    @State private var spoolInnerDiameter: String = "25"
    @State private var spoolWidth: String = "30"
    
    // Line diameter
    @State private var lineDiameter: String = "0.25"
    
    // Results
    @State private var calculatedLength: Double?
    @State private var showingResult = false
    
    // Saved presets
    @AppStorage("savedSpools") private var savedSpoolsData: Data = Data()
    @State private var savedSpools: [SpoolPreset] = []
    @State private var showingSaveSheet = false
    @State private var presetName = ""
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Info card
                    infoCard
                    
                    // Spool dimensions
                    spoolDimensionsSection
                    
                    // Line diameter
                    lineDiameterSection
                    
                    // Calculate button
                    CustomButtonView(title: "Calculate", icon: "function", style: .primary) {
                        calculateLineLength()
                    }
                    .disabled(!isInputValid)
                    .opacity(isInputValid ? 1 : 0.5)
                    
                    // Result
                    if let length = calculatedLength {
                        resultSection(length: length)
                    }
                    
                    // Saved presets
                    if !savedSpools.isEmpty {
                        presetsSection
                    }
                }
                .adaptivePadding()
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Spool Calculator")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
        .onAppear {
            loadPresets()
        }
        .sheet(isPresented: $showingSaveSheet) {
            savePresetSheet
        }
    }
    
    private var isInputValid: Bool {
        guard let outer = Double(spoolOuterDiameter),
              let inner = Double(spoolInnerDiameter),
              let width = Double(spoolWidth),
              let line = Double(lineDiameter) else {
            return false
        }
        return outer > inner && width > 0 && line > 0 && outer > 0 && inner >= 0
    }
    
    private var infoCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppTheme.primary)
            
            Text("Calculate how much line you need to fill your reel spool.")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var spoolDimensionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spool Dimensions (\(diameterUnit))")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                dimensionRow(title: "Outer Diameter", value: $spoolOuterDiameter, hint: "Total spool diameter")
                Divider().background(AppTheme.background)
                dimensionRow(title: "Inner Diameter", value: $spoolInnerDiameter, hint: "Arbor/core diameter")
                Divider().background(AppTheme.background)
                dimensionRow(title: "Width", value: $spoolWidth, hint: "Spool width")
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var lineDiameterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Line Diameter (\(diameterUnit))")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            HStack {
                TextField("", text: $lineDiameter)
                    .placeholder(when: lineDiameter.isEmpty) {
                        Text("0.25").foregroundColor(AppTheme.textMuted)
                    }
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(diameterUnit)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private func dimensionRow(title: String, value: Binding<String>, hint: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textPrimary)
                Text(hint)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
            }
            
            Spacer()
            
            TextField("", text: value)
                .keyboardType(.decimalPad)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.primary)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
            
            Text(diameterUnit)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textMuted)
                .frame(width: 30)
        }
        .padding(16)
    }
    
    private func resultSection(length: Double) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Line Needed")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textMuted)
                    .textCase(.uppercase)
                
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(String(format: "%.0f", displayLength(length)))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(AppTheme.primary)
                    
                    Text(lengthUnit)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            // Additional info
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text(String(format: "%.0f", displayLength(length) / 100))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("100m spools")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                }
                
                Rectangle()
                    .fill(AppTheme.textMuted.opacity(0.3))
                    .frame(width: 1, height: 40)
                
                VStack(spacing: 4) {
                    Text(String(format: "%.0f", displayLength(length) / 150))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("150m spools")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                }
            }
            
            // Save button
            Button(action: { showingSaveSheet = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save Preset")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.primary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Presets")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                ForEach(Array(savedSpools.enumerated()), id: \.element.id) { index, preset in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    Button(action: { loadPreset(preset) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(preset.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text("\(preset.outerDiameter)×\(preset.width)mm, line \(preset.lineDiameter)mm")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textMuted)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(AppTheme.primary)
                        }
                        .padding(16)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            deletePreset(preset)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var savePresetSheet: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preset Name")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.textMuted)
                            .textCase(.uppercase)
                        
                        TextField("", text: $presetName)
                            .placeholder(when: presetName.isEmpty) {
                                Text("My Reel").foregroundColor(AppTheme.textMuted)
                            }
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(16)
                            .background(AppTheme.cardBackground)
                            .cornerRadius(AppTheme.cornerRadiusMedium)
                    }
                    
                    CustomButtonView(title: "Save", style: .primary) {
                        savePreset()
                        showingSaveSheet = false
                    }
                    .disabled(presetName.isEmpty)
                    .opacity(presetName.isEmpty ? 0.5 : 1)
                    
                    Spacer()
                }
                .adaptivePadding()
                .padding(.vertical, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Save Preset")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingSaveSheet = false
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
    
    // MARK: - Calculations
    
    private func calculateLineLength() {
        guard let outer = Double(spoolOuterDiameter),
              let inner = Double(spoolInnerDiameter),
              let width = Double(spoolWidth),
              let line = Double(lineDiameter) else {
            return
        }
        
        // Convert to standard units if needed (mm for calculation)
        let outerMM = diameterUnit == "inches" ? outer * 25.4 : outer
        let innerMM = diameterUnit == "inches" ? inner * 25.4 : inner
        let widthMM = diameterUnit == "inches" ? width * 25.4 : width
        let lineMM = diameterUnit == "inches" ? line * 25.4 : line
        
        // Formula: L = π × (D² - d²) × W / (4 × t²)
        // Where: D = outer diameter, d = inner diameter, W = width, t = line diameter
        let lengthMM = Double.pi * (pow(outerMM, 2) - pow(innerMM, 2)) * widthMM / (4 * pow(lineMM, 2))
        
        // Convert mm to metres
        calculatedLength = lengthMM / 1000
        
        withAnimation {
            showingResult = true
        }
    }
    
    private func displayLength(_ metres: Double) -> Double {
        lengthUnit == "yards" ? metres * 1.09361 : metres
    }
    
    // MARK: - Presets
    
    private func loadPresets() {
        if let decoded = try? JSONDecoder().decode([SpoolPreset].self, from: savedSpoolsData) {
            savedSpools = decoded
        }
    }
    
    private func savePreset() {
        let preset = SpoolPreset(
            name: presetName,
            outerDiameter: spoolOuterDiameter,
            innerDiameter: spoolInnerDiameter,
            width: spoolWidth,
            lineDiameter: lineDiameter
        )
        savedSpools.append(preset)
        
        if let encoded = try? JSONEncoder().encode(savedSpools) {
            savedSpoolsData = encoded
        }
        
        presetName = ""
    }
    
    private func loadPreset(_ preset: SpoolPreset) {
        spoolOuterDiameter = preset.outerDiameter
        spoolInnerDiameter = preset.innerDiameter
        spoolWidth = preset.width
        lineDiameter = preset.lineDiameter
        calculateLineLength()
    }
    
    private func deletePreset(_ preset: SpoolPreset) {
        savedSpools.removeAll { $0.id == preset.id }
        if let encoded = try? JSONEncoder().encode(savedSpools) {
            savedSpoolsData = encoded
        }
    }
}

// MARK: - Spool Preset Model

struct SpoolPreset: Codable, Identifiable {
    let id: UUID
    let name: String
    let outerDiameter: String
    let innerDiameter: String
    let width: String
    let lineDiameter: String
    
    init(id: UUID = UUID(), name: String, outerDiameter: String, innerDiameter: String, width: String, lineDiameter: String) {
        self.id = id
        self.name = name
        self.outerDiameter = outerDiameter
        self.innerDiameter = innerDiameter
        self.width = width
        self.lineDiameter = lineDiameter
    }
}

// MARK: - Preview

struct SpoolCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SpoolCalculatorView()
        }
    }
}
