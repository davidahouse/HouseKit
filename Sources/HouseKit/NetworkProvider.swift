//
//  NetworkProvider.swift
//  francis
//
//  Created by David House on 8/15/20.
//

import Foundation
import Combine

@available(iOS 13.0, tvOS 13.0, *)
open class NetworkProvider {
    let session: URLSession
    private var disposables = Set<AnyCancellable>()

    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            self.session = URLSession(configuration: URLSessionConfiguration.default)
        }
    }

    public func request<T: Decodable>(url: URL) -> AnyPublisher<T, ServiceError> {
        debugPrint(">>> \(url)")

        let publisher: AnyPublisher<T, ServiceError> =
            session.dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode()
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        return .parsing(description: "Data corrupted error \(context.debugDescription)")
                    case .typeMismatch(let typeMismatch, let context):
                        return .parsing(description: "Type \(typeMismatch) mismatch: \(context.debugDescription) in path: \(context.codingPath)")
                    default:
                        return .parsing(description: "\(decodingError)")
                    }
                } else {
                    return .parsing(description: error.localizedDescription)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        return publisher
    }
}

extension Publisher where Output == Data {

    func decode<T: Decodable>(as type: T.Type = T.self,
                              using decoder: JSONDecoder = .init()) -> Publishers.Decode<Self, T, JSONDecoder> {
        return decode(type: type, decoder: decoder)
    }
}
