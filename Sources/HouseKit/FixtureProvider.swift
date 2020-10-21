//
//  MockProvider.swift
//  francis
//
//  Created by David House on 8/15/20.
//

import Foundation
import Combine

@available(iOS 13.0, tvOS 13.0, *)

public enum FixtureResponse<T> {
    case loading
    case error(ServiceError)
    case results(T)
}

open class FixtureProvider {

    public init() { }

    public func fetchPublisher<T>(_ value: FixtureResponse<T>?) -> AnyPublisher<T, ServiceError> {

        guard let value = value else {
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(.network(description: "No fixture found")))})
        }

        switch value {
        case .loading:
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { _ in })
        case .error(let error):
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.failure(error))})
        case .results(let result):
            return AnyPublisher<T, ServiceError>(Future<T, ServiceError> { promise in promise(.success(result))})
        }
    }
}
