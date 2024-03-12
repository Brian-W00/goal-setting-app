//
//  YouNeedGoalsApp.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

@main
struct YouNeedGoalsApp: App {
    
    @StateObject private var todayGoalStore = TodayGoalStore()
    @StateObject private var longTermGoalStore = LongTermGoalStore()
    @State private var isShowingSplashScreen = true
    @AppStorage("launchCount") var launchCount: Int = 0
    
    init() {
        let defaultValues = ["launchCount": 0, "Initial Launch": Date()] as [String : Any]
        UserDefaults.standard.register(defaults: defaultValues)
//        #if DEBUG
//        UserDefaults.standard.set(0, forKey: "launchCount")
//        #endif
        launchCount += 1
        UserDefaults.standard.set(launchCount, forKey: "launchCount")
        if UserDefaults.standard.object(forKey: "Initial Launch") == nil {
            UserDefaults.standard.set(Date(), forKey: "Initial Launch")
        }
        let currentLaunchCount = UserDefaults.standard.integer(forKey: "launchCount")
        if let initialLaunchDate = UserDefaults.standard.object(forKey: "Initial Launch") as? Date {
            print("Current Launch Count: \(currentLaunchCount)")
            print("Initial Launch Date: \(initialLaunchDate)")
        }
    }


    var body: some Scene {
        WindowGroup {
            if isShowingSplashScreen {
                SplashScreenView(isShowing: $isShowingSplashScreen)
                    .onAppear {
                        Task {
                            do {
                                try await todayGoalStore.load()
                                try await longTermGoalStore.load()
                            } catch {
                                print("An error occurred: \(error.localizedDescription)")
                            }
                        }
                    }
            } else {
                ContentView(
                    todayGoals: $todayGoalStore.todayGoals,
                    longTermGoals: $longTermGoalStore.longTermGoals,
                    saveAction: {
                        Task {
                            do {
                                try await todayGoalStore.save(todayGoals: todayGoalStore.todayGoals)
                                try await longTermGoalStore.save(longTermGoals: longTermGoalStore.longTermGoals)
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                    },
                    launchCount: $launchCount,
                    todayGoalStore: todayGoalStore,
                    longTermGoalStore: longTermGoalStore
                )
            }
        }
    }
}





