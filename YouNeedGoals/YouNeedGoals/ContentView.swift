//
//  ContentView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

enum ActiveAlert: Identifiable {
    case rateApp, instruction
    var id: Self { self }
}


struct ContentView: View {
    
    @Binding var todayGoals: [TodayGoal]
    @Binding var longTermGoals: [LongTermGoal]
    let saveAction: ()->Void
    @Environment(\.scenePhase) private var scenePhase
    @Binding var launchCount: Int
    var todayGoalStore: TodayGoalStore
    var longTermGoalStore: LongTermGoalStore
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        TabView {
            
            TodayGoalPercentView(todayGoals: $todayGoals, todayGoalStore: todayGoalStore) 
            .tabItem {
                Label("Today", systemImage: "sun.max")
            }
            .onChange(of: scenePhase) {
                if scenePhase == .inactive { saveAction() }
            }
        
            LongTermView(longTermGoals: $longTermGoals, longTermGoalStore: longTermGoalStore)
                .tabItem {
                    Label("Long Term", systemImage: "calendar")
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .inactive { saveAction() }
                }
        }
        
        .onAppear {
            // Check if this is the 3rd launch to show the rate app alert
            if launchCount == 3 {
                activeAlert = .rateApp
            }
            if launchCount <= 1 {
                activeAlert = .instruction
            }
        }
        
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .rateApp:
                return Alert(
                    title: Text("Rate this App"),
                    message: Text("If you enjoy using this app, please take a moment to rate it in the App Store. Thank you for your support!"),
                    primaryButton: .default(Text("Rate Now"), action: {}),
                    secondaryButton: .cancel(Text("Later"))
                )
            case .instruction:
                return Alert(
                    title: Text("Quick Tips"),
                    message: Text("Long press on a goal to delete it. Remember, today's goals will disappear after 11:59 PM."),
                    dismissButton: .default(Text("Got it!"))
                )
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(todayGoals: .constant(TodayGoal.sampleData), longTermGoals: .constant(LongTermGoal.sampleData), saveAction: {}, launchCount: .constant(3), todayGoalStore: TodayGoalStore(), longTermGoalStore: LongTermGoalStore())
    }
}
