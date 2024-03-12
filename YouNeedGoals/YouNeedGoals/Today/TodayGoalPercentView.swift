//
//  TodayGoalPercentView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct TodayGoalPercentView: View {
    
    @Binding var todayGoals: [TodayGoal]
    @State var isShowingTodayView = false
    var todayGoalStore: TodayGoalStore
    
    var body: some View {
        NavigationStack {
            Spacer()
            PercentView(todayGoals: $todayGoals)
            Spacer()
            if todayGoals.filter({ $0.isFinished }).count == todayGoals.count && todayGoals.count != 0 {
                Text("Congratulations! 🎉")
                    .font(.title2)
                    .padding()
            }
            Button(action: {
                isShowingTodayView = true
                print("Showing Today's Goals button was pressed")
            }) {
                Text("Show Today's Goals")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            Spacer()
            .navigationTitle("You Finished")
            .navigationDestination(isPresented: $isShowingTodayView) {
                TodayView(todayGoals: $todayGoals, todayGoalStore: todayGoalStore)
            }
        }
        
    }
}



struct PercentView: View {
    
    @Binding var todayGoals: [TodayGoal]
    let gradient = Gradient(colors: [.purple, .blue])
    
    var body: some View {
        VStack {
            let totalGoals = Float(todayGoals.count)
            let finishedCount = Float(todayGoals.filter { $0.isFinished }.count)
            let finishedPercent = totalGoals > 0 ? finishedCount / totalGoals : 0
            VStack {
                Gauge(value: finishedPercent, in: 0...1) {
                } currentValueLabel: {
                    Text("\(Int(finishedPercent * 100))%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
                        .clipShape(Circle()) 
                        .shadow(color: .gray, radius: 3, x: 0, y: 1)
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .scaleEffect(5)
            .tint(gradient)
        }
    }
}




struct TodayGoalPercentView_Previews: PreviewProvider {
    static var previews: some View {
        TodayGoalPercentView(todayGoals: .constant(TodayGoal.sampleData), todayGoalStore: TodayGoalStore())
    }
}


