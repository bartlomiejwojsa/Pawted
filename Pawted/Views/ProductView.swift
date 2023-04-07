//
//  ProductView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct ProductView: View, Equatable {
    static func == (lhs: ProductView, rhs: ProductView) -> Bool {
        return lhs.product == rhs.product && lhs.isLiked == rhs.isLiked
    }
    let product: Product
    private var productImageUrl: String
    private var productTitle: String
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var productService: ProductService

    @State private var isLiked: Bool  // Pass the isLiked binding from outside

    init(product: Product) {
        self.product = product
        self.productImageUrl = product.imageUrl ?? ""
        self.productTitle = product.title
        self.isLiked = product.likes > 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                URLImageView(url: productImageUrl)
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .clipped()
                HStack {
                    Text(productTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    LikeButtonView(isLiked: $isLiked)
                }
                Spacer()

            }
            .background(Color.systemBackground)
            .onTapGesture(count: 2) {
                DispatchQueue.main.async {
                    self.isLiked.toggle()
                }
                
            }
            .onChange(of: isLiked) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    if let user = userService.appUser {
                        DispatchQueue.main.async {
                            self.productService.updateLike(for: self.product, by: user, isLiked: newValue)
                        }
                    }
                    
                })
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: Product(id: "000", title: "test",description: "XD", imageUrl: "https://fastly.picsum.photos/id/307/200/300.jpg?hmac=35wY422fzycUwe-jX9k1JwdWurkBiowwCBswfyVXY4E", price: 10, likes: 5))
    }
}
