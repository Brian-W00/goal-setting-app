//
//  LongTermGoalStore.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import Foundation

import SwiftUI


@MainActor
class LongTermGoalStore: ObservableObject {
    
    @Published var longTermGoals: [LongTermGoal] = []
    
    private static func fileURL() throws -> URL {
        let fileURL = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        .appendingPathComponent("longTermGoals.data")
        print("File URL for storing long term goals: \(fileURL)")
        return fileURL
    }


    func load() async throws {
//        try clearData()
        let task = Task<[LongTermGoal], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyGoals = try JSONDecoder().decode([LongTermGoal].self, from: data)
            return dailyGoals
        }
        let longTermGoals = try await task.value
        self.longTermGoals = longTermGoals
    }
    
    
    func save(longTermGoals: [LongTermGoal]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(longTermGoals)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            print("Saved longTermGoals to file: \(outfile.path)")
        }
        _ = try await task.value
    }
    
    func clearData() throws {
        let fileURL = try Self.fileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
    
}

