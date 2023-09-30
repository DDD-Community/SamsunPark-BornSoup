//
//  OZTextField.swift
//  PresentationKit
//
//  Created by 신의연 on 2023/09/03.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import SwiftUI

struct OZTextFieldStyle: TextFieldStyle {
    enum Constants {
        static let textFieldPadding = 10
    }
    
    @Binding var text: String
    @Binding var invalidation: Bool
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        invalidation: Binding<Bool>
    ) {
        self._text = text
        self._invalidation = invalidation
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            DesignSystemKitAsset.icSearch16.swiftUIImage
                .renderingMode(.template)
            
            configuration
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
            Button {
                text = ""
            } label: {
                if text.count > 0 && isFocused {
                    DesignSystemKitAsset.icSearchDelete18.swiftUIImage
                }
            }
        }
        .onChange(of: invalidation) { newValue in
            isFocused = false
        }
        .padding(Constants.textFieldPadding)
    }
}

struct OZTextField: View {
    enum Constants {
        static let textFieldCornerRadius = 6
        static let rectangleCornerRadius = 23
        static let rectangleLineWidth = 1
    }
    let title: any StringProtocol
    @Binding var text: String
    @Binding var invalidation: Bool
    @State private var changingValue: Bool = false
    
    init(
        title: any StringProtocol,
        text: Binding<String>,
        invalidation: Binding<Bool> = .constant(true)
    ) {
        self.title = title
        self._text = text
        self._invalidation = invalidation
    }
    
    var body: some View {
        TextField(title, text: $text) { changed in
            changingValue = changed
        }
        .cornerRadius(Constants.textFieldCornerRadius)
        .overlay(
            Group {
                RoundedRectangle(cornerRadius: Constants.rectangleCornerRadius)
                    .stroke(
                        invalidation ? Color.error : Color.orangeGray1,
                        lineWidth: Constants.rectangleLineWidth
                    )
            }
        )
        .textFieldStyle(
            OZTextFieldStyle(
                text: $text,
                invalidation: $invalidation
            )
        )
    }
}
#if DEBUG
struct OZTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OZTextField(title: "플레이스 홀더", text: .constant("123"), invalidation: .constant(true))
            OZTextField(title: "플레이스 홀더", text: .constant("123"), invalidation: .constant(false))
        }
    }
}
#endif
