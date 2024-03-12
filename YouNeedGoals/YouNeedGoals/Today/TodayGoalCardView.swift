//
//  TodayGoalCardView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct TodayGoalCardView: View {
    
    let todayGoal: TodayGoal
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(todayGoal.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(15)
        .shadow(radius: 7)
        .padding(.horizontal)
    }
}


#Preview {
    TodayGoalCardView(todayGoal: TodayGoal.sampleData[0])
}
