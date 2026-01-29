import SwiftUI

struct AddRodView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var editingRod: FishingRod?
    
    @State private var name: String = ""
    @State private var selectedIcon: String = "rod_1"
    @State private var lineType: LineType = .monofilament
    @State private var diameter: Double = 0.14
    @State private var strength: String = ""
    @State private var brand: String = ""
    @State private var length: String = ""
    @State private var lastChangeDate: Date = Date()
    @State private var reminderDays: Double = 60
    @State private var reminderTrips: Double = 20
    @State private var autoReminder: Bool = true
    
    private let icons = ["rod_1", "rod_2", "rod_3", "rod_4", "rod_5", "rod_6"]
    private let diameters = stride(from: 0.08, through: 0.40, by: 0.02).map { $0 }
    
    private var isEditing: Bool { editingRod != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Icon picker
                        iconPickerSection
                        
                        // Name
                        nameSection
                        
                        // Line details
                        lineDetailsSection
                        
                        // Last change date
                        dateSection
                        
                        // Reminder settings
                        reminderSection
                        
                        // Save button
                        CustomButtonView(title: isEditing ? "Save Changes" : "Add Rod", style: .primary) {
                            saveRod()
                        }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.5 : 1)
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(isEditing ? "Edit Rod" : "Add New Rod")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
            .onAppear {
                if let rod = editingRod {
                    loadRodData(rod)
                }
            }
        }
    }
    
    private var iconPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Icon")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            HStack(spacing: 12) {
                ForEach(icons, id: \.self) { icon in
                    Button(action: { selectedIcon = icon }) {
                        RodIconView(iconName: icon, size: 50)
                            .overlay(
                                Circle()
                                    .stroke(selectedIcon == icon ? AppTheme.primary : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
        }
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rod Name")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            TextField("", text: $name)
                .placeholder(when: name.isEmpty) {
                    Text("e.g. Winter Rod #1")
                        .foregroundColor(AppTheme.textMuted)
                }
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textPrimary)
                .padding(16)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var lineDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Line Details")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                // Line type
                HStack {
                    Text("Type")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Picker("Type", selection: $lineType) {
                        ForEach(LineType.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(AppTheme.primary)
                }
                .padding(16)
                
                Divider().background(AppTheme.background)
                
                // Diameter
                HStack {
                    Text("Diameter")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Picker("Diameter", selection: $diameter) {
                        ForEach(diameters, id: \.self) { d in
                            Text(d.formatDiameter()).tag(d)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(AppTheme.primary)
                }
                .padding(16)
                
                Divider().background(AppTheme.background)
                
                // Strength (optional)
                HStack {
                    Text("Strength (lb)")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    TextField("", text: $strength)
                        .placeholder(when: strength.isEmpty) {
                            Text("Optional").foregroundColor(AppTheme.textMuted)
                        }
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(16)
                
                Divider().background(AppTheme.background)
                
                // Brand (optional)
                HStack {
                    Text("Brand")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    TextField("", text: $brand)
                        .placeholder(when: brand.isEmpty) {
                            Text("Optional").foregroundColor(AppTheme.textMuted)
                        }
                        .multilineTextAlignment(.trailing)
                        .frame(width: 120)
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(16)
                
                Divider().background(AppTheme.background)
                
                // Length (optional)
                HStack {
                    Text("Length (m)")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    TextField("", text: $length)
                        .placeholder(when: length.isEmpty) {
                            Text("Optional").foregroundColor(AppTheme.textMuted)
                        }
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(16)
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Line Change")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            DatePicker("", selection: $lastChangeDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .accentColor(AppTheme.primary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reminder Settings")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 16) {
                // Days slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Remind after")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                        Spacer()
                        Text("\(Int(reminderDays)) days")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                    }
                    
                    Slider(value: $reminderDays, in: 30...180, step: 5)
                        .accentColor(AppTheme.primary)
                }
                
                // Trips slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Or after")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                        Spacer()
                        Text("\(Int(reminderTrips)) trips")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                    }
                    
                    Slider(value: $reminderTrips, in: 10...50, step: 5)
                        .accentColor(AppTheme.primary)
                }
                
                // Auto reminder toggle
                Toggle(isOn: $autoReminder) {
                    Text("Auto-adjust by condition")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.primary))
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private func loadRodData(_ rod: FishingRod) {
        name = rod.name
        selectedIcon = rod.iconName
        lineType = rod.lineType
        diameter = rod.lineDiameter
        strength = rod.lineStrength.map { String($0) } ?? ""
        brand = rod.lineBrand ?? ""
        length = rod.lineLength.map { String(Int($0)) } ?? ""
        lastChangeDate = rod.lastChangeDate
        reminderDays = Double(rod.reminderDays)
        reminderTrips = Double(rod.reminderTrips)
        autoReminder = rod.autoReminder
    }
    
    private func saveRod() {
        let rod = FishingRod(
            id: editingRod?.id ?? UUID(),
            name: name,
            iconName: selectedIcon,
            lineType: lineType,
            lineDiameter: diameter,
            lineStrength: Double(strength),
            lineBrand: brand.isEmpty ? nil : brand,
            lineLength: Double(length),
            lastChangeDate: lastChangeDate,
            usageCount: editingRod?.usageCount ?? 0,
            fishCaught: editingRod?.fishCaught ?? 0,
            reminderDays: Int(reminderDays),
            reminderTrips: Int(reminderTrips),
            autoReminder: autoReminder,
            changeHistory: editingRod?.changeHistory ?? []
        )
        
        if isEditing {
            dataManager.updateRod(rod)
        } else {
            dataManager.addRod(rod)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

// Placeholder modifier for TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct AddRodView_Previews: PreviewProvider {
    static var previews: some View {
        AddRodView()
            .environmentObject(DataManager())
    }
}
