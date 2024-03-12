//
//  TodayView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct TodayView: View {
    
    @State private var isPresentingTodayGoalDetailView = false
    @Binding var todayGoals: [TodayGoal]
    var todayGoalStore: TodayGoalStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach($todayGoals) { $todayGoal in
                        NavigationLink(destination: TodayGoalDetailView(todayGoal: $todayGoal, todayGoals: $todayGoals, todayGoalStore: todayGoalStore)) {
                            TodayGoalCardView(todayGoal: todayGoal)
                        }
                        .contextMenu {
                            Button(action: {
                                deleteGoal(todayGoal: todayGoal)
                                print("Delete was pressed, this goal was deleted")
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            Button(action: {
                                print("Cancel was pressed, nothing happened")
                            }) {
                                Label("Cancel", systemImage: "xmark.circle")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top)
            }
            .navigationTitle("All Today Goals")
            .toolbar {
                Button(action: {
                    print("Create new Today Goal button was pressed")
                    isPresentingTodayGoalDetailView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Today Goal")
            }
        }
        .sheet(isPresented: $isPresentingTodayGoalDetailView) {
            CreatingNewTodayGoalView(todayGoals: $todayGoals, isPresentingNewScrumView: $isPresentingTodayGoalDetailView, todayGoalStore: todayGoalStore)
        }
    }
    
    // Delete this goal from the todayGoals list
    func deleteGoal(todayGoal: TodayGoal) {
        todayGoals.removeAll { $0.id == todayGoal.id }
        Task {
            do {
                try await todayGoalStore.save(todayGoals: todayGoals)
                print("Goal deleted and changes saved to the file.")
            } catch {
                print("An error occurred while saving: \(error.localizedDescription)")
            }
        }
    }
    
}



struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(todayGoals: .constant(TodayGoal.sampleData), todayGoalStore: TodayGoalStore())
    }
}


