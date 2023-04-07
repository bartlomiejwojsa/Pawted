//
//  WelcomeView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 08/04/2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var isBlinking = false
    @State private var isTilting = false
    @State private var isRaising = false
    @State private var isWaving = false
    @State private var isShouting = false
    
    @Binding var connectionTestResult: Bool?
    @Binding var showWelcome: Bool
    
    private var testConnectionManager = TestConnectionManager()
    
    init(connectionTestResult: Binding<Bool?>, showWelcome: Binding<Bool>) {
        _connectionTestResult = connectionTestResult
        _showWelcome = showWelcome
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.yellow, .pink]), startPoint: .top, endPoint: .bottom)
                )
                .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image("bed")
                    }
                }
                .offset(x: -25, y:150)
                
                // Body
                HStack {
                    Image("tail")
                        .rotationEffect(.degrees(isWaving ? 0 : -10), anchor: .bottomTrailing)
                        .animation(.easeInOut.repeatCount(20, autoreverses: true), value: isWaving)
                }
                .offset(x:-80)
                
                HStack {
                    Image("body")
                }
                
                HStack(spacing: 82) {
                    Image("leftHand")
                        .rotationEffect(.degrees(isWaving ? 0 : -5), anchor: .center)
                        .animation(.easeInOut.repeatCount(5, autoreverses: true), value: isWaving)
                        .offset(x:-50)
                }
                // Face
                VStack {
                    Image("ears")
                }
                .offset(x: 100, y: -120 )

                // Face
                VStack {
                    Image("face")
                }
                .offset(x: 100, y: -120 )
                
                // Eyes, Nose and thoung
                VStack(spacing: -12) {
                    // Eyes
                    HStack(spacing: 32) {
                        ZStack { // Left eye
                            Image("eyelid")
                            Image("pipul")
                        }
                        ZStack { // Right eye
                            Image("eyelid")
                            Image("pipul")
                        }
                    }
                    .scaleEffect(y: isBlinking ? 1 : 0)
                    .offset(x: 110, y: -150)
                }

                
                VStack {
                    Text("Pawted")
                        .font(.custom("Didot", size: 72))
                        .foregroundColor(.black)
                        .padding()
                }
                .offset(y:350)
                if let safeConnectionTestResult = connectionTestResult, !safeConnectionTestResult {
                    VStack {
                        Text("Waking up test cloud server in progress... \nPlease stay calm")
                    }.offset(y:-350)
                }

                
            }
            

        } // All views
        .onAppear {
            withAnimation(.easeOut(duration: 0.2).delay(0.25).repeatForever()) {
                isBlinking.toggle()
            }
            
            withAnimation(.easeInOut(duration: 0.2).delay(0.5*4).repeatForever(autoreverses: true)) {
                isTilting.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.2).repeatForever(autoreverses: true)) {
                isWaving.toggle()
            }
            
            withAnimation(.easeInOut(duration: 1).delay(0.5*3.4).repeatForever(autoreverses: true)) {
                isRaising.toggle()
            }
            
            withAnimation(.easeInOut(duration: 1).delay(0.5*3.4).repeatForever(autoreverses: true)) {
                isShouting.toggle()
            }
            
            if (AppConfiguration.shared.shouldTestConnection) {
                self.runInitialConnectionTest()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showWelcome = false
            }
        }
    }
    
    private func runInitialConnectionTest() {
        self.runConnectionTest()
        
        // Schedule a repeating timer with 15-second intervals
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { timer in
            if self.connectionTestResult == true {
                timer.invalidate()
                return
            }
            self.runConnectionTest()
        }
    }
    
    private func runConnectionTest() {
        self.testConnectionManager.getTestPage { result in
            switch result {
            case .success(_):
                print("Connection test succeeded")
                self.connectionTestResult = true
            case .failure(_):
                print("Connection test failed, retrying in 15 seconds...")
                self.connectionTestResult = false

            }
        }
    }
    
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(connectionTestResult: .constant(false), showWelcome: .constant(true))
    }
}
