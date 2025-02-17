//
//  OZWeb.swift
//  PresentationKit
//
//  Created by 고병학 on 10/1/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import ComposableArchitecture

import Foundation

public struct OZWeb: Reducer {
    
    public init() {}
    
    public struct State: Equatable {
        var url: String = ""
        public init(url: String) {
            self.url = url
        }
    }
    
    public enum Action: Equatable {
        case didTapBackButton
    }
    
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .didTapBackButton:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
