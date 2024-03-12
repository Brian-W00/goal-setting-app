//
//  LongTermGoalEditView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/1/24.
//

import SwiftUI

struct LongTermGoalEditView: View {
    
    @Binding var longTermGoal: LongTermGoal
    @Binding var isEditing: Bool
    
    // Keyboard will disappear if the screen was touched anyplace
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    var body: some View {
        VStack{
            if isEditing == true {
                Text("Edit Long Term Goal")
                    .font(.system(size: 26, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text("Create Long Term Goal")
                    .font(.system(size: 26, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer()
            ScrollView {
                VStack(alignment: .leading)  {
                    Spacer()
                    Text("Goal title")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.leading)
                        .foregroundColor(.gray)
                    TextField("Enter Goal Title", text: $longTermGoal.title)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                        .padding([.leading, .trailing, .bottom])
                    Text("Goal description")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.leading)
                        .foregroundColor(.gray)
                    TextEditor(text: $longTermGoal.description)
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



struct LongTermGoalEditView_Previews: PreviewProvider {
    static var previews: some View {
        LongTermGoalEditView(longTermGoal: .constant(LongTermGoal.sampleData[0]), isEditing: .constant(true))
    }
}

