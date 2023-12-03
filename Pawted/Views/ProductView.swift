//
//  ProductView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    private var productImageUrl: String
    private var productTitle: String
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var productService: ProductService

    
    let width: CGFloat
    let height: CGFloat

    init(viewModel: ProductViewModel, width: CGFloat, height: CGFloat) {
        self.viewModel = viewModel
        self.productImageUrl = viewModel.product.imageUrl ?? ""
        self.productTitle = viewModel.product.title
        self.width = width
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ProductImageView(viewModel: viewModel, withURL: viewModel.product.imageUrl ?? "", width: geometry.size.width)
                HStack {
                    Text(productTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.product.price ?? 0.00))")
                    LikeButtonView(productVM: viewModel)
                }
                Spacer()

            }
            .background(Color.systemBackground)
            .onTapGesture(count: 2) {
                if let user = userService.appUser {
                    DispatchQueue.main.async {
                        let isCurrentlyLiked = self.viewModel.product.likes.contains(user.nick)
                        let beforeActionVM = self.viewModel.product.likes
                        withAnimation {
                            if (!isCurrentlyLiked) {
                                self.viewModel.product.likes.append(user.nick)
                            } else if (isCurrentlyLiked) {
                                self.viewModel.product.likes.remove(
                                    at: self.viewModel.product.likes.firstIndex(of: user.nick) ?? -1
                                )
                            }
                        }
                        self.productService.updateLike(for: self.viewModel.product, by: user, value: !isCurrentlyLiked) { result, error in
                            if !result {
                                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                                // revert model update
                                self.viewModel.product.likes = beforeActionVM
                            }
                        }
                    }
                }
            }
        }
        .frame(width: self.width, height: self.height)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(viewModel: ProductViewModel(product: Product(id: "000", title: "test",description: "XD", userId: ProductUser(email: "xd", nick: "xd"), imageUrl: "https://fastly.picsum.photos/id/307/200/300.jpg?hmac=35wY422fzycUwe-jX9k1JwdWurkBiowwCBswfyVXY4E", price: 10, likes: [])), width: 100, height: 100)
            .environmentObject(ProductService())
            .environmentObject(UserService())
    }
}
