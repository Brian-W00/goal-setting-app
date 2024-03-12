//
//  TodayGoalStore.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import Foundation

import SwiftUI


@MainActor
class TodayGoalStore: ObservableObject {
    @Published var todayGoals: [TodayGoal] = []
    
    init() {
        setupMidnightCleaningTask()
    }
    
    private static func fileURL() throws -> URL {
        let fileURL = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        .appendingPathComponent("todayGoals.data")
        print("File URL for storing today goals: \(fileURL)")
        return fileURL
    }


    func load() async throws {
        let task = Task<[TodayGoal], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyGoals = try JSONDecoder().decode([TodayGoal].self, from: data)
            return dailyGoals
        }
        let todayGoals = try await task.value
        self.todayGoals = todayGoals
    }
    
    
    func save(todayGoals: [TodayGoal]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(todayGoals)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            print("Saved todayGoals to file: \(outfile.path)")
        }
        _ = try await task.value
    }

    
    
    func clearData() throws {
        let fileURL = try Self.fileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
    
    // Clear Today Goal when pass 12 a.m.
    func setupMidnightCleaningTask() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearExpiredTodayGoals),
            name: .NSCalendarDayChanged,
            object: nil
        )
    }
    
    @objc func clearExpiredTodayGoals() {
        DispatchQueue.main.async {
            Task {
                do {
                    try self.clearData()
                    self.todayGoals.removeAll()
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    func addGoal(_ newGoal: TodayGoal) async throws {
        todayGoals.append(newGoal)
        try await save(todayGoals: todayGoals)
    }


    
}

