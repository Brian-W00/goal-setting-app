//
//  CreatingNewTodayGoalView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct CreatingNewTodayGoalView: View {
    
    @State private var newTodayGoal = TodayGoal.emptyTodayGoal
    @Binding var todayGoals: [TodayGoal]
    @Binding var isPresentingNewScrumView: Bool
    var todayGoalStore: TodayGoalStore
    
    var body: some View {
        NavigationStack {
            TodayGoalEditView(todayGoal: $newTodayGoal, isEditing: .constant(false))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                            print("Dismiss button was pressed, the goal was not be created")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            todayGoals.append(newTodayGoal)
                            Task {
                                do {
                                    try await todayGoalStore.save(todayGoals: todayGoals)
                                    print("Add button was pressed, the goal has been created and saved")
                                } catch {
                                    print("An error occurred while saving: \(error.localizedDescription)")
                                }
                            }
                            isPresentingNewScrumView = false
                        }
                    }
                }
        }

    }
}


struct CreatingNewTodayGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingNewTodayGoalView(todayGoals: .constant(TodayGoal.sampleData), isPresentingNewScrumView: .constant(true), todayGoalStore: TodayGoalStore())
    }
}


