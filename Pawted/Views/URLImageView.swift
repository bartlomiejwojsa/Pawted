//
//  URLImageView.swift
//
//  Created by Bartłomiej Wojsa on 26/03/2023.
//

import Foundation
import SwiftUI

struct URLImageView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    
    init(url: String) {
        self.imageLoader.load(url: url)
    }
    
    var body: some View {
        Group {
            if let downloadedImage = self.imageLoader.downloadedImage {
                Image(uiImage: downloadedImage)
                    .resizable()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}


struct URLImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            URLImageView(url: "https://cdn2.hubspot.net/hubfs/53/parts-url.jpg")
        }
    }
}
