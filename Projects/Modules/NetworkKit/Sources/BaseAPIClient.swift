//
//  BaseAPIClient.swift
//  NetworkKit
//
//  Created by 고병학 on 2023/07/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import Alamofire

import Foundation

public final class BaseAPIClient {
    
    public init() {}
    
    private let baseURL: URL = URL(string: "https://oneul.store/")!
    
    private(set) var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
    
    public func requestJSON<T: Decodable>(
        _ url: String,
        type: T.Type,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async -> (T?, Error?) {
        let request: DataRequest = session.request(
            baseURL.appending(path: url),
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        )
        
        let task = request.serializingDecodable(type)
        var responseValue: T?
        var responseError: AFError?
        
        switch await task.result {
        case .success(let value): responseValue = value
        case .failure(let error): responseError = error
        }
        
        return (responseValue, responseError)
    }
}
