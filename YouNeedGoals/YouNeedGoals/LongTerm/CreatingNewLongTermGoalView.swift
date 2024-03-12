//
//  CreatingNewLongTermGoalView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct CreatingNewLongTermGoalView: View {
    
    @State private var newLongTermGoal = LongTermGoal.emptyLongTermGoal
    @Binding var longTermGoals: [LongTermGoal]
    @Binding var isPresentingNewScrumView: Bool
    var longTermGoalStore: LongTermGoalStore
    
    var body: some View {
        NavigationStack {
            LongTermGoalEditView(longTermGoal: $newLongTermGoal, isEditing: .constant(false))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                            print("Dismiss button was pressed, the Long Term Goal was not be created")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            longTermGoals.append(newLongTermGoal)
                            // Save the updated list of longTermGoals
                            Task {
                                do {
                                    try await longTermGoalStore.save(longTermGoals: longTermGoals)
                                    print("Add button was pressed, the Long Term Goal has been created and saved")
                                } catch {
                                    print("An error occurred while saving the long-term goals: \(error.localizedDescription)")
                                }
                            }
                            isPresentingNewScrumView = false
                        }
                    }
                }
        }
    }
    
}



struct CreatingNewLongTermGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingNewLongTermGoalView(longTermGoals: .constant(LongTermGoal.sampleData), isPresentingNewScrumView: .constant(true), longTermGoalStore: LongTermGoalStore())
    }
}


