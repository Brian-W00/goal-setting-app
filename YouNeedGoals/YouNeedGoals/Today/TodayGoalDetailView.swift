//
//  TodayGoalDetailView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct TodayGoalDetailView: View {
    
    @Binding var todayGoal: TodayGoal
    @State var editingTodayGoal = TodayGoal.emptyTodayGoal
    @State private var isPresentingTodayGoalEditView = false
    @Binding var todayGoals: [TodayGoal]
    var todayGoalStore: TodayGoalStore
    
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
                        print("The Finish button was pressed")
                    }
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
                print("Edit button was pressed, goes to the edit page")
            }
        }
        
        .sheet(isPresented: $isPresentingTodayGoalEditView) {
            NavigationStack {
                TodayGoalEditView(todayGoal: $editingTodayGoal, isEditing: .constant(true))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingTodayGoalEditView = false
                                print("Cancel was pressed, nothing happened")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingTodayGoalEditView = false
                                todayGoal = editingTodayGoal
                                Task {
                                    do {
                                        try await todayGoalStore.save(todayGoals: todayGoals)
                                        print("Done was pressed, the goal has been edited and saved")
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



struct TodayGoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TodayGoalDetailView(todayGoal: .constant(TodayGoal.sampleData[0]), todayGoals: .constant(TodayGoal.sampleData), todayGoalStore: TodayGoalStore())
        }
    }
}


