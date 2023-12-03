//
//  ProductImageView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/12/2023.
//

import SwiftUI

struct ProductImageView: View {
    @ObservedObject var viewModel: ProductViewModel
    let withURL: String
    let width: CGFloat
    @State private var hasClickedNotImplemented = false

    init(viewModel: ProductViewModel, withURL: String, width: CGFloat) {
        self.viewModel = viewModel
        self.withURL = withURL
        self.width = width
    }
    var body: some View {
        ZStack(alignment: .topTrailing) {
            URLImageView(url: withURL)
                .scaledToFill()
                .frame(width: width, height: width)
                .clipped()
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .top, endPoint: .center))
            HStack {
                Button(action: {
                    hasClickedNotImplemented.toggle()
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .font(.system(size: width/7))
                }

            }
            .padding(5)
        }
        .presentStandardBottomToast(isPresented: $hasClickedNotImplemented) {
            ToastManager.getOperationToast(
                message: "Functionality not yet implemented!", iconSystemName: "exclamationmark.circle"
            )
        }
    }
}

struct ProductImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProductImageView(viewModel: ProductViewModel(product: Product(id: "000", title: "test",description: "XD", userId: ProductUser(email: "xd", nick: "xd"), imageUrl: "https://fastly.picsum.photos/id/307/200/300.jpg?hmac=35wY422fzycUwe-jX9k1JwdWurkBiowwCBswfyVXY4E", price: 10, likes: [])), withURL: "https://fastly.picsum.photos/id/307/200/300.jpg?hmac=35wY422fzycUwe-jX9k1JwdWurkBiowwCBswfyVXY4E", width: 100)
            .environmentObject(ProductService())
            .environmentObject(UserService())
    }
}
