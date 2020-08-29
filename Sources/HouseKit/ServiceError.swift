//
//  ServiceError.swift
//  francis
//
//  Created by David House on 7/31/20.
//

import Foundation

public enum ServiceError: Error {
  case parsing(description: String)
  case network(description: String)
}

extension ServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .parsing(let description):
            return "Parsing error: \(description)"
        case .network(let description):
            return "Network error: \(description)"
        }
    }
}
