//
//  LongTermGoalCardView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct LongTermGoalCardView: View {
    
    let longTermGoal: LongTermGoal

    var body: some View {
        VStack() {
            Spacer()
            Text(longTermGoal.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
            Spacer()
            CardGaugeView(longTermGoal: longTermGoal)
            Spacer()
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(15)
        .shadow(radius: 7)
        .padding(.horizontal)
    }
}


struct CardGaugeView: View {
    let longTermGoal: LongTermGoal
    var body: some View {
        let finishedShortTermGoalsCount = Double(longTermGoal.shortTermGoals.filter { $0.isFinished == true }.count)
        let totalShortTermGoalsCount = Double(longTermGoal.shortTermGoals.count)
        Gauge(value: finishedShortTermGoalsCount, in: 0...totalShortTermGoalsCount) {
        }
        .frame(width: 300)
    }
}




#Preview {
    LongTermGoalCardView(longTermGoal: LongTermGoal.sampleData[0])
}



