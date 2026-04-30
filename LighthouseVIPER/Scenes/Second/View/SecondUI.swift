//
//  Untitled.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/30.
//

import SwiftUI

@MainActor
struct SecondUI: View {
    
    @StateObject var observable: SecondUIObservable
    @State private var rootSize: CGSize = .zero
    
    @State private var contentWidth: Double = .zero
    init(observable: SecondUIObservable) {
        _observable = StateObject(wrappedValue: observable)
        observable.presenter.input.onViewDidLoad()
    }
        
    var body: some View {
        
        GeometryView { proxy in
            
            VStack(spacing: 0) {
                Text(observable.viewState.id)
                    .frame(maxWidth: .infinity)
                Spacer()
                Color.gray
                    .frame(width: proxy.size.width, height: 1)
                    .padding(.bottom, 8)
                Button(observable.viewState.password) {
                    observable.presenter.input.tapCallBack()
                }
                .buttonStyle(CustomButtonStyle())
            }
            .padding(.top, 32)
            .padding(.horizontal, 24)
            .navigationTitle("Second")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .font(.custom("HiraginoSansW5", size: 18))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background {
                Color.red.overlay(
                    Color.black.opacity(configuration.isPressed ? 0.5 : 0)
                )
            }
            .border(Color.black, width: 1)
            .cornerRadius(24)
            .contentShape(Rectangle())
    }
}

#Preview {
    SecondUI(
        observable: SecondUIObservable.preview(viewState: SecondViewState(
            id: "Hello, Viper!",
            password: "back main!",
        ))
    )
}
