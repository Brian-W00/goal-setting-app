//
//  SplashScreenView.swift
//  YouNeedGoals
//
//  Created by Brian Wei on 3/5/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var startAnimation = false
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(startAnimation ? 1.0 : 0.1)
                Text("You Need Goals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(startAnimation ? 1 : 0)
                Text("Developed by: Ertong Wei")
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(startAnimation ? 1 : 0)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                self.isShowing = false
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                startAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isShowing = false
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}



#Preview {
    SplashScreenView(isShowing: .constant(true))
}
