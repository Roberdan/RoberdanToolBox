//
//   CardActionButton.swift
//  MirrorableHR
//
//  Created by Roberto D’Angelo on 25/09/2020.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct CardActionButton: View {
    var label: String
    var systemImage: String
    var action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(Font.title.bold())
                .imageScale(.large)
                .frame(width: 44, height: 44)
                .padding()
                .contentShape(Rectangle())
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
        .accessibility(label: Text(label))
    }
}

struct CardActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CardActionButton(label: "Close", systemImage: "xmark", action: {})
            .previewLayout(.sizeThatFits)
    }
}
