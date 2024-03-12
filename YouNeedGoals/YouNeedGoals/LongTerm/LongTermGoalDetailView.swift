//
//  LongTermGoalDetailView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct LongTermGoalDetailView: View {
    
    @Binding var longTermGoal: LongTermGoal
    @State var editingLongTermGoal = LongTermGoal.emptyLongTermGoal
    @State private var isPresentingLongTermGoalEditView = false
    @State private var isPresentingTodayGoalDetailView = false
    @Binding var selectedGoalIds: Set<UUID>
    @Binding var filterOption: FilterOption
    @State var backToLongTermView = false
    @Binding var longTermGoals: [LongTermGoal]
    var longTermGoalStore: LongTermGoalStore
    
    // Update selectedGoalIds
    // If all Short Term Goals in the Long Term Goal are finished, the status of the Long Term Goal is finished
    // If one Short Term Goal was changed to unfinished, the status of the Long Term Goal should be unfinished
    // Then the selectedGoalIds should be update
    func updateSelectedGoalIds(with id: UUID) {
        if filterOption == .completed {
            if longTermGoal.isFinished == true {
                if !selectedGoalIds.contains(id) {
                    selectedGoalIds.insert(id)
                }
            } else {
                if selectedGoalIds.contains(id) {
                    selectedGoalIds.remove(id)
                }
            }
        } else if filterOption == .uncompleted {
            if longTermGoal.isFinished == true {
                if selectedGoalIds.contains(id) {
                    selectedGoalIds.remove(id)
                }
            } else {
                if !selectedGoalIds.contains(id) {
                    selectedGoalIds.insert(id)
                }
            }
        }
    }

    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                GaugeView(longTermGoal: longTermGoal)
                Spacer()
                Text(longTermGoal.title)
                    .font(.system(size: 32, weight: .heavy))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Spacer()
                Text(longTermGoal.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                Spacer()
                Text("Created At:")
                    .font(.system(size: UIFont.systemFontSize, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                Text(dateFormatter.string(from: longTermGoal.createdDate))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                Spacer()
                Button(action: {
                    withAnimation {
                        longTermGoal.isFinished.toggle()
                        if longTermGoal.isFinished {
                            for index in longTermGoal.shortTermGoals.indices {
                                longTermGoal.shortTermGoals[index].isFinished = true
                            }
                        } else {
                            for index in longTermGoal.shortTermGoals.indices {
                                longTermGoal.shortTermGoals[index].isFinished = false
                            }
                        }
                    }
                    print("Finish button was pressed")
                }) {
                    Image(systemName: longTermGoal.isFinished ? "checkmark.square.fill" : "square")
                        .foregroundColor(longTermGoal.isFinished ? .green : .gray)
                        .font(.largeTitle)
                        .padding()
                        .background(longTermGoal.isFinished ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .disabled(longTermGoal.shortTermGoals.count == 0)
                .buttonStyle(PlainButtonStyle())
                Spacer(minLength: 20)
                Divider()
                Text("Short Term Goals")
                    .font(.headline)
                    .padding(.horizontal)
            
                LazyVStack(spacing: 20) {
                    ForEach($longTermGoal.shortTermGoals) { $shortTermGoal in
                        NavigationLink(destination: ShortTermGoalDetailView(todayGoal: $shortTermGoal, longTermGoal: $longTermGoal, longTermGoals: $longTermGoals, longTermGoalStore: longTermGoalStore)) {
                            TodayGoalCardView(todayGoal: shortTermGoal)
                        }
                        .contextMenu {
                            Button(action: {
                                deleteGoal(shortTermGoal: shortTermGoal)
                                print("Delete button was pressed, the Short Term Goal has been deleted")
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            Button(action: {
                                print("Cancel button was pressed, nothing happened")
                            }) {
                                Label("Cancel", systemImage: "xmark.circle")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top)
    
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }

        .onDisappear {
            updateSelectedGoalIds(with: longTermGoal.id)
        }
        
        .sheet(isPresented: $isPresentingTodayGoalDetailView) {
            CreatingNewShortTermGoalView(isPresentingNewScrumView: $isPresentingTodayGoalDetailView, longTermGoal: $longTermGoal, longTermGoals: $longTermGoals, longTermGoalStore: longTermGoalStore)
        }
        
        .toolbar {
            Button(action: {
                isPresentingTodayGoalDetailView = true
                print("Create button was pressed, enter Create Short Term Goal page")
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Today Goal")
            
            Button("Edit") {
                isPresentingLongTermGoalEditView = true
                editingLongTermGoal = longTermGoal
                print("Edit button was pressed, enter Edit Short Term Goal page")
            }
        }
        
        .sheet(isPresented: $isPresentingLongTermGoalEditView) {
            NavigationStack {
                LongTermGoalEditView(longTermGoal: $editingLongTermGoal, isEditing: .constant(true))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                print("Cancel button was pressed, the change has not been saved")
                                isPresentingLongTermGoalEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingLongTermGoalEditView = false
                                longTermGoal = editingLongTermGoal
                                Task {
                                    do {
                                        try await longTermGoalStore.save(longTermGoals: longTermGoals)
                                        print("Done button was pressed, the changes have been saved")
                                    } catch {
                                        print("An error occurred while saving: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
            }
        }
        
    }
        
    // Delelte the Short Term Goal from the Long Term Goal
    func deleteGoal(shortTermGoal: TodayGoal) {
        longTermGoal.shortTermGoals.removeAll { $0.id == shortTermGoal.id }
        if longTermGoal.shortTermGoals.count == 0 {
            longTermGoal.isFinished = true
        } else {
            let allFinished = longTermGoal.shortTermGoals.allSatisfy { $0.isFinished }
            longTermGoal.isFinished = allFinished
        }
        Task {
            do {
                try await longTermGoalStore.save(longTermGoals: longTermGoals)
                print("Goal deleted and changes saved to the file.")
            } catch {
                print("An error occurred while saving: \(error.localizedDescription)")
            }
        }
    }
    
}



struct LongTermGoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LongTermGoalDetailView(longTermGoal: .constant(LongTermGoal.sampleData[0]), selectedGoalIds: .constant(Set(arrayLiteral: LongTermGoal.sampleData[0].id)), filterOption: .constant(.all), longTermGoals: .constant(LongTermGoal.sampleData), longTermGoalStore: LongTermGoalStore())
        }
    }
}

