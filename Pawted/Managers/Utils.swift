//
//  Utils.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 23/10/2023.
//

import Foundation

struct Utils {
    static func parseStringToDecimal(text: String, precision: Int = 2) -> String? {
        // Filter out non-digit characters
        var filteredValue = text.replacingOccurrences(of: ",", with: ".").filter { "0123456789.".contains($0) }

        // Ensure there's only one comma
        if let firstCommaIndex = filteredValue.firstIndex(of: ".") {
            let remainingText = filteredValue.suffix(from: filteredValue.index(after: firstCommaIndex))
            if remainingText.contains(".") {
                filteredValue.remove(at: firstCommaIndex)
            }
        }

        // Limit precision to two decimal places
        if let dotIndex = filteredValue.firstIndex(of: ".") {
            let remainingText = filteredValue.suffix(from: filteredValue.index(after: dotIndex))
            if remainingText.count > 2 {
                filteredValue = String(filteredValue.prefix(upTo: filteredValue.index(dotIndex, offsetBy: 3)))
            }
        }
        return filteredValue
    }
}
