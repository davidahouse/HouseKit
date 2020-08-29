//
//  NetworkProvider.swift
//  francis
//
//  Created by David House on 8/15/20.
//

import Foundation
import Combine

@available(iOS 13.0, *)
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
              .mapError { error in
                .network(description: error.localizedDescription)
              }
              .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
              }
                .receive(on: RunLoop.main)
              .eraseToAnyPublisher()
        return publisher
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, ServiceError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .formatted(Constants.iso8601Full)
  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
        if let decodingError = error as? DecodingError {
            let resultString = String(data: data, encoding: .utf8)
            debugPrint(">>> \(resultString ?? "")")

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
    .eraseToAnyPublisher()
}
