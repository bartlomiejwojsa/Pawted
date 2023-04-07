//
//  LikeButtonView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/05/2023.
//

import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    
    @State var animateLiked: Bool = false
    var body: some View {
        HStack {
            Image(systemName: animateLiked ? "heart.fill" : "heart")
                .foregroundColor(animateLiked ? .red : .gray)
        }
        .onAppear {
            animateLiked = isLiked
        }
        .onChange(of: isLiked) { newValue in
            withAnimation {
                animateLiked = isLiked
            }
        }

    }
}

struct LikeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LikeButtonView(
            isLiked: .constant(true)
        )
        .environmentObject(UserService())
        .environmentObject(ProductService())
    }
}
