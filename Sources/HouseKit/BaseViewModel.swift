//
//  BaseViewModel.swift
//  francis
//
//  Created by David House on 7/31/20.
//

import Foundation
import Combine

// MARK: - ViewModelState

public enum ViewModelState<T> {
    case loading
    case networkError
    case results(T)
}

// MARK: - BaseViewModel

@available(iOS 13.0, *)
open class BaseViewModel<T>: ObservableObject {

    // MARK: - Public properties

    @Published public var state: ViewModelState<T> = .loading

    public var publisher: AnyPublisher<T, ServiceError>? = nil {
        didSet {
            self.fetch()
        }
    }

    // MARK: - Initializer

    public init(state: ViewModelState<T> = .loading, publisher: AnyPublisher<T, ServiceError>? = nil) {
        self.state = state
        self.publisher = publisher
        fetch()
    }

    // MARK: - Private properties

    private var disposables = Set<AnyCancellable>()

    // MARK: - Public methods

    public func fetch() {
        self.publisher?.sink(receiveCompletion: { result in
          if case let .failure(error) = result {
            print("Error receiving \(error)")
            DispatchQueue.main.async {
                self.state = .networkError
            }
          }
        }, receiveValue: { value in
            DispatchQueue.main.async {
                self.state = .results(value)
            }
        }).store(in: &self.disposables)
    }
}
