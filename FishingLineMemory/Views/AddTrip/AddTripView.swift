import SwiftUI

struct AddTripView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var preselectedRodId: UUID?
    
    @State private var tripDate: Date = Date()
    @State private var selectedRodIds: Set<UUID> = []
    @State private var fishCaught: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Date picker
                        dateSection
                        
                        // Rod selection
                        rodSelectionSection
                        
                        // Fish caught
                        fishCaughtSection
                        
                        // Notes
                        notesSection
                        
                        // Save button
                        CustomButtonView(title: "Add Trip", style: .primary) {
                            saveTrip()
                        }
                        .disabled(selectedRodIds.isEmpty)
                        .opacity(selectedRodIds.isEmpty ? 0.5 : 1)
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Fishing Trip")
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
                if let rodId = preselectedRodId {
                    selectedRodIds.insert(rodId)
                }
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Trip Date")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            DatePicker("", selection: $tripDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .accentColor(AppTheme.primary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var rodSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rods Used")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            if dataManager.rods.isEmpty {
                Text("No rods added yet")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textMuted)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cornerRadiusMedium)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(dataManager.rods.enumerated()), id: \.element.id) { index, rod in
                        if index > 0 {
                            Divider().background(AppTheme.background)
                        }
                        
                        Button(action: {
                            if selectedRodIds.contains(rod.id) {
                                selectedRodIds.remove(rod.id)
                            } else {
                                selectedRodIds.insert(rod.id)
                            }
                        }) {
                            HStack {
                                RodIconView(iconName: rod.iconName, size: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(rod.name)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Text(rod.lineType.description)
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                if selectedRodIds.contains(rod.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.primary)
                                        .font(.system(size: 22))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(AppTheme.textMuted)
                                        .font(.system(size: 22))
                                }
                            }
                            .padding(12)
                        }
                    }
                }
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
            }
        }
    }
    
    private var fishCaughtSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Fish Caught (Optional)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            TextField("", text: $fishCaught)
                .placeholder(when: fishCaught.isEmpty) {
                    Text("0").foregroundColor(AppTheme.textMuted)
                }
                .keyboardType(.numberPad)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textPrimary)
                .padding(16)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            TextEditor(text: $notes)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textPrimary)
                .frame(minHeight: 80)
                .padding(12)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private func saveTrip() {
        let trip = FishingTrip(
            date: tripDate,
            rodIds: Array(selectedRodIds),
            fishCaught: Int(fishCaught) ?? 0,
            notes: notes.isEmpty ? nil : notes
        )
        
        dataManager.addTrip(trip)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .environmentObject(DataManager())
    }
}
