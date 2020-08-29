//
//  MockProvider.swift
//  francis
//
//  Created by David House on 8/15/20.
//

import Foundation
import Combine

@available(iOS 13.0, *)
open class FixtureProvider {

    var error: ServiceError?

    public init() { }

    public func fetchPublisher<T>(_ value: T?) -> AnyPublisher<T, ServiceError> {
        if let value = value {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.success(value))})
        } else if let error = error {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(error))})
        } else {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(.network(description: "No fixture found")))})
        }
    }
}
