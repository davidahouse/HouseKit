//
//  MockProvider.swift
//  francis
//
//  Created by David House on 8/15/20.
//

import Foundation
import Combine

@available(iOS 13.0, tvOS 13.0, *)
open class FixtureProvider {

    public var error: ServiceError?
    public var loading: Bool = false

    public init() { }

    public func fetchPublisher<T>(_ value: T?) -> AnyPublisher<T, ServiceError> {
        if loading {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { _ in })
        }

        if let error = error {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(error))})
        }

        if let value = value {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.success(value))})
        } else {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(.network(description: "No fixture found")))})
        }
    }
}
