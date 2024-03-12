//
//  GaugeView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/2/24.
//

import SwiftUI

struct GaugeView: View {
    
    let longTermGoal: LongTermGoal
    
    var body: some View {

        let finishedShortTermGoalsCount = Double(longTermGoal.shortTermGoals.filter { $0.isFinished == true }.count)
        let totalShortTermGoalsCount = Double(longTermGoal.shortTermGoals.count)
        let percentage = totalShortTermGoalsCount > 0 ? Int(finishedShortTermGoalsCount * 100 / totalShortTermGoalsCount) : 100

        Gauge(value: finishedShortTermGoalsCount, in: 0...totalShortTermGoalsCount) {
        } currentValueLabel: {
            Text("\(Int(percentage))%")
        }
        .frame(width: 300)
        
    }
}



#Preview {
    GaugeView(longTermGoal: LongTermGoal.sampleData[0])
}



