//
//  LongTermGoal.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import Foundation

struct LongTermGoal: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var isFinished: Bool
    var shortTermGoals: [TodayGoal]
    var createdDate: Date

    init(title: String, description: String, isFinished: Bool, shortTermGoals: [TodayGoal], createdDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isFinished = isFinished
        self.shortTermGoals = shortTermGoals
        self.createdDate = createdDate
    }
}


extension LongTermGoal {
    static var emptyLongTermGoal: LongTermGoal {
        LongTermGoal(title: "", description: "", isFinished: true, shortTermGoals: [])
    }
}


extension LongTermGoal {
    static let sampleData: [LongTermGoal] =
    [
        LongTermGoal(title: "Long Term Goal 0", description: "Content 0", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 1", description: "Content 1", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 2", description: "Content 2", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 3", description: "Content 3", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 4", description: "Content 4", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 5", description: "Content 5", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 6", description: "Content 6", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 7", description: "Content 7", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 8", description: "Content 8", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]]),
        LongTermGoal(title: "Long Term Goal 9", description: "Content 9", isFinished: false,
                     shortTermGoals: [TodayGoal.sampleData[0], TodayGoal.sampleData[1]])
    ]
}
