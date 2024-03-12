//
//  ShortTermGoalEditView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/4/24.
//

import SwiftUI

struct ShortTermGoalEditView: View {
    
    @Binding var shortTermGoal: TodayGoal
    @Binding var isEditing: Bool
    
    // Keyboard will disappear if the screen was touched anyplace
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack{
            if isEditing == true {
                Text("Edit Goal")
                    .font(.system(size: 26, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text("Create Goal")
                    .font(.system(size: 26, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer()
            ScrollView {
                VStack(alignment: .leading)  {
                    Spacer()
                    Text("Edit goal title")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.leading)
                    TextField("Enter Goal Title", text: $shortTermGoal.title)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                        .padding([.leading, .trailing, .bottom])
                    Text("Edit goal description")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.leading)
                    TextEditor(text: $shortTermGoal.description)
                        .frame(height: 300)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                        .padding([.leading, .trailing, .bottom])
                    Spacer()
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
    }
    
}



struct ShortTermGoalEditView_Previews: PreviewProvider {
    static var previews: some View {
        ShortTermGoalEditView(shortTermGoal: .constant(TodayGoal.sampleData[0]), isEditing: .constant(true))
    }
}
