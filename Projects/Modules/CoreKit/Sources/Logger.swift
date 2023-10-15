//
//  Logger.swift
//  CoreKit
//
//  Created by 고병학 on 10/8/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import Foundation

public struct Logger {
    public init() {}
    
    static public func log(_ message: String?) {
        #if DEBUG
        print("🚧 LOGGER \nTime:\(Date())")
        print(message ?? "Unknown error")
        #endif
    }
}
