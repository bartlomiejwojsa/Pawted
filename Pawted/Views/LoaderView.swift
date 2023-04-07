//
//  LoaderView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 23/10/2023.
//

import SwiftUI

struct LoaderView: View {
    var message: String?

    @Binding var isLoading: Bool

    var body: some View {
        if isLoading {
            ProgressView(message ?? "Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .foregroundColor(Color.white)
                .ignoresSafeArea()
                .font(.title)
        }
    }
}

#Preview {
    LoaderView(isLoading: .constant(true))
}
