import SwiftUI

struct RodDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    let rod: FishingRod
    
    @State private var showingChangeLineSheet = false
    @State private var showingAddTripSheet = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var currentRod: FishingRod {
        dataManager.rods.first { $0.id == rod.id } ?? rod
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with icon
                        headerSection
                        
                        // Line details
                        lineDetailsSection
                        
                        // Current status
                        currentStatusSection
                        
                        // Actions
                        actionsSection
                        
                        // Change history
                        if !currentRod.changeHistory.isEmpty {
                            historySection
                        }
                        
                        // Delete button
                        deleteSection
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(AppTheme.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditSheet = true }) {
                        Text("Edit")
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .adaptiveSheet(isPresented: $showingChangeLineSheet) {
            ChangeLineSheet(rod: currentRod)
                .environmentObject(dataManager)
        }
        .adaptiveSheet(isPresented: $showingAddTripSheet) {
            AddTripView(preselectedRodId: rod.id)
                .environmentObject(dataManager)
        }
        .adaptiveSheet(isPresented: $showingEditSheet) {
            AddRodView(editingRod: currentRod)
                .environmentObject(dataManager)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Rod"),
                message: Text("Are you sure you want to delete \"\(currentRod.name)\"? This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    dataManager.deleteRod(currentRod)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            RodIconView(iconName: currentRod.iconName, size: 100)
            
            Text(currentRod.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
    
    private var lineDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Line Details")
            
            VStack(spacing: 0) {
                detailRow("Type", currentRod.lineType.description)
                Divider().background(AppTheme.background)
                detailRow("Diameter", currentRod.lineDiameter.formatDiameter())
                
                if let strength = currentRod.lineStrength {
                    Divider().background(AppTheme.background)
                    detailRow("Strength", strength.formatStrength())
                }
                
                if let brand = currentRod.lineBrand, !brand.isEmpty {
                    Divider().background(AppTheme.background)
                    detailRow("Brand", brand)
                }
                
                if let length = currentRod.lineLength {
                    Divider().background(AppTheme.background)
                    detailRow("Length", length.formatLength())
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var currentStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Current Status")
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Changed")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                        Text(currentRod.lastChangeDate.formatted())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Age")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                        Text("\(currentRod.daysSinceChange) days")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Times Used")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                        Text("\(currentRod.usageCount) trips")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Fish Caught")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                        Text("\(currentRod.fishCaught)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Health")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                        Spacer()
                        Text("\(Int(currentRod.healthPercentage))%")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    
                    ProgressBarView(progress: currentRod.healthPercentage, status: currentRod.status)
                }
                
                StatusBadgeView(status: currentRod.status)
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Actions")
            
            VStack(spacing: 12) {
                CustomButtonView(title: "I Changed the Line", icon: "arrow.triangle.2.circlepath", style: .primary) {
                    showingChangeLineSheet = true
                }
                
                CustomButtonView(title: "Add Fishing Trip", icon: "plus.circle", style: .secondary) {
                    showingAddTripSheet = true
                }
            }
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Change History")
            
            VStack(spacing: 0) {
                ForEach(Array(currentRod.changeHistory.prefix(5).enumerated()), id: \.element.id) { index, change in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(change.date.formatted())
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(change.reason.rawValue)
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        if change.daysUsed > 0 || change.tripsUsed > 0 {
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(change.daysUsed) days")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textMuted)
                                Text("\(change.tripsUsed) trips")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textMuted)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var deleteSection: some View {
        Button(action: { showingDeleteAlert = true }) {
            HStack {
                Image(systemName: "trash")
                Text("Delete Rod")
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(AppTheme.statusDanger)
        }
        .padding(.top, 16)
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(AppTheme.textMuted)
            .textCase(.uppercase)
    }
    
    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(16)
    }
}

// MARK: - Change Line Sheet

struct ChangeLineSheet: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    let rod: FishingRod
    
    @State private var selectedReason: ChangeReason = .scheduled
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Why are you changing the line?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    VStack(spacing: 12) {
                        ForEach(ChangeReason.allCases.filter { $0 != .newRod }, id: \.self) { reason in
                            Button(action: { selectedReason = reason }) {
                                HStack {
                                    Text(reason.rawValue)
                                        .font(.system(size: 16))
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                    
                                    if selectedReason == reason {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppTheme.primary)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(AppTheme.textMuted)
                                    }
                                }
                                .padding(16)
                                .background(AppTheme.cardBackground)
                                .cornerRadius(AppTheme.cornerRadiusMedium)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    CustomButtonView(title: "Confirm Line Change", style: .primary) {
                        dataManager.changeLine(for: rod.id, reason: selectedReason)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
}

struct RodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RodDetailView(rod: FishingRod(
            name: "Winter Rod #1",
            lineType: .monofilament,
            lineDiameter: 0.14,
            lineStrength: 4.0,
            lineBrand: "Sufix Elite",
            lineLength: 100,
            lastChangeDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
            usageCount: 8,
            fishCaught: 23
        ))
        .environmentObject(DataManager())
    }
}
