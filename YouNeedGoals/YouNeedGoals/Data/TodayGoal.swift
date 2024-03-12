//
//  TodayGoal.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import Foundation


struct TodayGoal: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var isFinished: Bool
    var createdDate: Date

    init(title: String, description: String, isFinished: Bool, createdDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isFinished = isFinished
        self.createdDate = createdDate
    }
}


extension TodayGoal {
    static var emptyTodayGoal: TodayGoal {
        TodayGoal(title: "", description: "", isFinished: false)
    }
}


extension TodayGoal {
    static let sampleData: [TodayGoal] =
    [
        TodayGoal(title: "Today Goal 0", description: "Content 0", isFinished: false),
        TodayGoal(title: "Today Goal 1", description: "Content 1", isFinished: false),
        TodayGoal(title: "Today Goal 2", description: "Content 2", isFinished: false),
        TodayGoal(title: "Today Goal 3", description: "Content 3", isFinished: false),
        TodayGoal(title: "Today Goal 4", description: "Content 4", isFinished: true),
        TodayGoal(title: "Today Goal 5", description: "Content 5", isFinished: true),
        TodayGoal(title: "Today Goal 6", description: "Content 6", isFinished: true),
        TodayGoal(title: "Today Goal 7", description: "Content 7", isFinished: false),
        TodayGoal(title: "Today Goal 8", description: "Content 8", isFinished: false),
        TodayGoal(title: "Today Goal 9", description: "Content 9", isFinished: false)
    ]
}
