//
//  ShortTermGoalDetailView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/2/24.
//

import SwiftUI

struct ShortTermGoalDetailView: View {
    
    @Binding var todayGoal: TodayGoal
    @Binding var longTermGoal: LongTermGoal
    @State var editingTodayGoal = TodayGoal.emptyTodayGoal
    @State private var isPresentingTodayGoalEditView = false
    @Binding var longTermGoals: [LongTermGoal]
    var longTermGoalStore: LongTermGoalStore
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium 
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text(todayGoal.title)
                    .font(.system(size: 32, weight: .heavy))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Spacer()
                Text(todayGoal.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                Spacer()
                Text("Created At:")
                    .font(.system(size: UIFont.systemFontSize, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                Text(dateFormatter.string(from: todayGoal.createdDate))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                Spacer()
                Button(action: {
                    withAnimation {
                        todayGoal.isFinished.toggle()
                        var flag = true
                        for index in longTermGoal.shortTermGoals.indices {
                            if longTermGoal.shortTermGoals[index].isFinished == false {
                                flag = false
                                break
                            }
                        }
                        longTermGoal.isFinished = flag
                    }
                    print("Finish button was pressed")
                }) {
                    Image(systemName: todayGoal.isFinished ? "checkmark.square.fill" : "square")
                        .foregroundColor(todayGoal.isFinished ? .green : .gray)
                        .font(.largeTitle)
                        .padding()
                        .background(todayGoal.isFinished ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }

        .toolbar {
            Button("Edit") {
                isPresentingTodayGoalEditView = true
                editingTodayGoal = todayGoal
                print("Edit button was pressed, enter Short Term Goal Edit page")
            }
        }
        
        .sheet(isPresented: $isPresentingTodayGoalEditView) {
            NavigationStack {
                ShortTermGoalEditView(shortTermGoal: $editingTodayGoal, isEditing: .constant(true))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingTodayGoalEditView = false
                                print("Cancel button was pressed, the change not be saved")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingTodayGoalEditView = false
                                todayGoal = editingTodayGoal
                                Task {
                                    do {
                                        try await longTermGoalStore.save(longTermGoals: longTermGoals)
                                        print("Done button was pressed, the Short Term Goal has been created and saved")
                                    } catch {
                                        print("An error occurred while saving: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
            }
        }

    }
}



struct ShortTermGoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShortTermGoalDetailView(todayGoal: .constant(LongTermGoal.sampleData[0].shortTermGoals[0]), longTermGoal: .constant(LongTermGoal.sampleData[0]), longTermGoals: .constant(LongTermGoal.sampleData), longTermGoalStore: LongTermGoalStore())
        }
    }
}

