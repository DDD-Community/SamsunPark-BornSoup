//
//  OZDropbox.swift
//  PresentationKit
//
//  Created by 신의연 on 2023/09/03.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import SwiftUI

public struct OZDropboxButtonStyle: ButtonStyle {
    enum Constant {
        static let lineWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 10
    }
    
    var invalidation: Bool
    
    public init(
        invalidation: Bool = false
    ) {
        self.invalidation = invalidation
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .overlay(
                Group {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .stroke(
                            invalidation ? Color.init(hex: 0xF10000) : Color.orangeGray5,
                            lineWidth: Constant.lineWidth
                        )
                }
            )
    }
}

public struct OZDropbox: View {
    public var title: String
    public var invalidation: Bool
    public var action: (() -> Void)?
    
    public init(
        title: String,
        invalidation: Bool = false,
        action: (() -> Void)?
    ) {
        self.title = title
        self.invalidation = invalidation
        self.action = action
    }
    
    public var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(title)
                    .lineLimit(1)
                    .font(.Body1.regular)
                    .foregroundColor(.orangeGray5)
                Spacer()
                Image.DK.icCaredown22.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(.orangeGray3)
            }
            .padding(12)
            
        }
        .buttonStyle(
            OZDropboxButtonStyle(invalidation: self.invalidation)
        )
    }
}

#if DEBUG
struct OZDropbox_Previews: PreviewProvider {
    static var previews: some View {
        OZDropbox(
            title: "행사를 선택해주세요",
            invalidation: false
        ) {
            print("pressed")
        }
    }
}
#endif
