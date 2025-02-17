//
//  SearchResult.swift
//  PresentationKit
//
//  Created by 신의연 on 11/12/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import ComposableArchitecture
import DomainKit
import Foundation

public struct SearchResultList: Reducer {
    public struct State: Equatable {
        var contentsList: [PreviewContentsModel]
        
        public init(
            contentsList: [PreviewContentsModel]
        ) {
            self.contentsList = contentsList
        }
    }
    
    public enum Action: Equatable {
        case cellTapped(PreviewContentsModel)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cellTapped:
                return .none
            }
        }
    }
}
