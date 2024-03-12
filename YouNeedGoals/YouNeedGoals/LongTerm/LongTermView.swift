//
//  LongTermView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

enum FilterOption {
    case all, completed, uncompleted
}


struct LongTermView: View {
    
    @State private var isPresentingLongTermGoalDetailView = false
    @Binding var longTermGoals: [LongTermGoal]
    @State private var showingFilterSheet = false
    @State private var filterOption: FilterOption = .all
    // selectedGoalIds is a set of ids that the corresponding goals will show
    // selectedGoalIds could be
    // ids of goals that are finished
    // ids of goals that are unfinished
    // ids of all goals
    @State var selectedGoalIds: Set<UUID> = []
    var longTermGoalStore: LongTermGoalStore
    
    // Update the selectedGoalIds
    private func updateSelectedGoalIds() {
        switch filterOption {
        case .all:
            selectedGoalIds = Set(longTermGoals.map { $0.id })
        case .completed:
            selectedGoalIds = Set(longTermGoals.filter { $0.isFinished }.map { $0.id })
        case .uncompleted:
            selectedGoalIds = Set(longTermGoals.filter { !$0.isFinished }.map { $0.id })
        }
    }
    
    var navigationTitle: String {
        switch filterOption {
        case .all:
            return "All Long Term Goals"
        case .completed:
            return "Completed"
        case .uncompleted:
            return "Uncompleted"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach($longTermGoals.filter { selectedGoalIds.contains($0.id) }) { $longTermGoal in
                        NavigationLink(destination: LongTermGoalDetailView(longTermGoal: $longTermGoal, selectedGoalIds: $selectedGoalIds, filterOption: $filterOption, longTermGoals: $longTermGoals, longTermGoalStore: longTermGoalStore)) {
                            LongTermGoalCardView(longTermGoal: longTermGoal)
                        }
                        .contextMenu {
                            Button(action: {
                                deleteGoal(longTermGoal: longTermGoal)
                                print("Delete button was pressed, the goal was deleted")
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
            
            .navigationTitle(navigationTitle)
            .toolbar {
                Button(action: {
                    isPresentingLongTermGoalDetailView = true
                    print("Create button was pressed, enter Create page")
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Today Goal")
                
                Button(action: {
                    showingFilterSheet = true
                    print("Filter button was pressed, enter selecting filter page")
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Filter Goals"), buttons: [
                    .default(Text("All")) { filterOption = .all; updateSelectedGoalIds()
                    print("All has been seleted")},
                    .default(Text("Completed")) { filterOption = .completed; updateSelectedGoalIds()
                    print("Completed has been selected")},
                    .default(Text("Uncompleted")) { filterOption = .uncompleted; updateSelectedGoalIds()
                    print("Uncompleted has beed selected")},
                    .cancel()
                ])
            }
            
        }
        .sheet(isPresented: $isPresentingLongTermGoalDetailView, onDismiss: updateSelectedGoalIds) {
            CreatingNewLongTermGoalView(longTermGoals: $longTermGoals, isPresentingNewScrumView: $isPresentingLongTermGoalDetailView, longTermGoalStore: longTermGoalStore)
        }
        .onAppear(perform: updateSelectedGoalIds)

    }
    
    // Delete goal
    func deleteGoal(longTermGoal: LongTermGoal) {
        longTermGoals.removeAll { $0.id == longTermGoal.id }
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



struct LongTermGoalView_Previews: PreviewProvider {
    static var previews: some View {
        LongTermView(longTermGoals: .constant(LongTermGoal.sampleData), longTermGoalStore: LongTermGoalStore())
    }
}
