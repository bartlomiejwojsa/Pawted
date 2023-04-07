//
//  ToastManager.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 23/10/2023.
//

import Foundation
import SimpleToast
import SwiftUI

struct ToastManager {
    static let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 1
    )
    
    static func getOperationToast(message: String = "Operation succeeded", iconSystemName: String = "checkmark.bubble") -> some View {
        HStack {
            Image(systemName: iconSystemName)
            Text(message)
        }
        .padding()
        .background(Color.blue.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }
}

public extension View {
    func presentStandardBottomToast<SimpleToastContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> SimpleToastContent
    ) -> some View {
        return simpleToast(isPresented: isPresented, options: ToastManager.toastOptions, content: content)
    }
}
