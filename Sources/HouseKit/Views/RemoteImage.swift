//
//  RemoteImage.swift
//  TopApps
//
//  Created by David House on 8/16/20.
//

import SwiftUI

@available(iOS 14.0, tvOS 14.0, *)
public struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    public var body: some View {
        selectImage()
            .resizable()
    }

    public init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}


struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, tvOS 14.0, *) {
            RemoteImage(url: "http://www.apple.com/favicon.ico")
        } else {
            // Fallback on earlier versions
        }
    }
}
