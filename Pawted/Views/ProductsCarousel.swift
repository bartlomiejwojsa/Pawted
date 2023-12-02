//
//  ProductsCarousel.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct ProductsCarousel: View {
    let products: [Product]
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .padding(.horizontal)
                Spacer()
            }

            if (products.isEmpty) {
                Text("Nothing here...")
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        ForEach(products, id: \.id) { product in
                            ProductView(product: product)
                                .frame(width: 250, height: 300)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ProductsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ProductsCarousel(products:[Product(id: "0000", title: "test", description: "XD", imageUrl: "test", price: 10, likes: 5)], title: "Kitties")
    }
}
