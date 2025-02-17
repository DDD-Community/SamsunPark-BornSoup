//
//  PrimaryButton.swift
//  PresentationKit
//
//  Created by 고병학 on 2023/09/03.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import SwiftUI

/// 참고링크
/// https://www.figma.com/file/1bD6fyajIDwiYmJVWzG5Mt/%EC%98%A4%3A%EC%A0%84?type=design&node-id=1102-17872&mode=dev
public struct PrimaryButton: View {
    private enum Constants {
        enum Sizes {
            static let FullRadius: CGFloat = 100
            static let HorizontalPadding: CGFloat = 24
            static let VerticalPadding: CGFloat = 16
        }
        
        enum Colors {
            static let SystemWhite: Color = .white
            static let ActivatedBackground: Color = .main1
            static let DeactivatedBackground: Color = .orangeGray6
        }
    }
    
    public init(
        title: String = "Button",
        isActivated: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.isActivated = isActivated
        self.action = action
    }
    
    public var title: String
    public var isActivated: Bool
    public var action: (() -> Void)?
    
    private var buttonColor: Color {
        isActivated ?
        Constants.Colors.ActivatedBackground
        : Constants.Colors.DeactivatedBackground
    }
    
    public var body: some View {
        Button {
            action?()
        } label: {
            Text(title)
                .font(.Title2.semiBold)
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Colors.SystemWhite)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, Constants.Sizes.HorizontalPadding)
                .padding(.vertical, Constants.Sizes.VerticalPadding)
                .background(buttonColor)
                .cornerRadius(Constants.Sizes.FullRadius)
        }
        .disabled(!isActivated)
    }
}

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "버튼 타이틀", isActivated: true) {
                print("Action")
            }
            PrimaryButton(title: "버튼 타이틀", isActivated: false) {
                print("Action")
            }
        }
    }
}
#endif
