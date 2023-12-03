//
//  LikeButtonView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/05/2023.
//

import SwiftUI

struct LikeButtonView: View {
    @EnvironmentObject var userService: UserService
    @ObservedObject var productVM: ProductViewModel

    init(productVM: ProductViewModel) {
        self.productVM = productVM
    }

    var body: some View {
        HStack {
            Image(systemName: productVM.product.likes.contains(userService.appUser?.nick ?? "") ? "heart.fill" : "heart")
                .foregroundColor(productVM.product.likes.contains(userService.appUser?.nick ?? "") ? .red : .gray)
        }
    }
}

//struct LikeButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikeButtonView(
//            isLiked: .constant(true)
//        )
//        .environmentObject(UserService())
//        .environmentObject(ProductService())
//    }
//}
