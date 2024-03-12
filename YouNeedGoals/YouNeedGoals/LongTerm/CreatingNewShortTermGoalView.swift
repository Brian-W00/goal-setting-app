//
//  CreatingNewShortTermGoalView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/2/24.
//

import SwiftUI

struct CreatingNewShortTermGoalView: View {
    
    @State private var newShortTermGoal = TodayGoal.emptyTodayGoal
    @Binding var isPresentingNewScrumView: Bool
    @Binding var longTermGoal: LongTermGoal
    @Binding var longTermGoals: [LongTermGoal]
    var longTermGoalStore: LongTermGoalStore
    
    var body: some View {
        NavigationStack {
            ShortTermGoalCreateView(shortTermGoal: $newShortTermGoal)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            longTermGoal.shortTermGoals.append(newShortTermGoal)
                            longTermGoal.isFinished = false
                            isPresentingNewScrumView = false
                            Task {
                                do {
                                    try await longTermGoalStore.save(longTermGoals: longTermGoals)
                                    print("Add button was pressed, the Short Term Goal has been created and saved")
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



struct CreatingNewShortTermGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreatingNewShortTermGoalView(isPresentingNewScrumView: .constant(true), longTermGoal: .constant(LongTermGoal.sampleData[0]), longTermGoals: .constant(LongTermGoal.sampleData), longTermGoalStore: LongTermGoalStore())
    }
}

