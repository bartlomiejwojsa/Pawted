//
//  ProductDetailsView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/12/2023.
//

import SwiftUI

struct ProductDetailsView: View {
    let viewModel: ProductViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.product.title)
        }
    }
}

#Preview {
    ProductDetailsView(viewModel: ProductViewModel(product: Product(id: "000", title: "test",description: "XD", userId: ProductUser(email: "xd", nick: "xd"), imageUrl: "https://fastly.picsum.photos/id/307/200/300.jpg?hmac=35wY422fzycUwe-jX9k1JwdWurkBiowwCBswfyVXY4E", price: 10, likes: [])))
}
