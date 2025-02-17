//
//  AllContents.swift
//  PresentationKit
//
//  Created by 신의연 on 2023/10/15.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import ComposableArchitecture

public struct AllContents: Reducer {
    public struct State: Equatable {
        public var contentsList: IdentifiedArrayOf<ContentsHorizontalList.State> = []
        
        public init(contentsList: IdentifiedArrayOf<ContentsHorizontalList.State>) {
            self.contentsList = contentsList
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case contentsList(id: ContentsHorizontalList.State.ID, action: ContentsHorizontalList.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .contentsList:
                return .none
            }
        }
        .forEach(\.contentsList, action: /Action.contentsList) {
            ContentsHorizontalList()
        }
    }
}
