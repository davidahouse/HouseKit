//
//  DelayedAppearView.swift
//  francis
//
//  Created by David House on 8/14/20.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public struct DelayedAppearView<Content: View>: View {

    // MARK: - Private Properties

    private let content: Content
    @State private var contentVisible: Bool = false

    // MARK: - Initializer

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        content
            .opacity(contentVisible ? 1 : 0)
            .animation(Animation.easeIn(duration: 1.0).delay(1.0))
        .onAppear() {
            self.contentVisible = true
        }
    }
}

struct DelayedAppearView_Previews: PreviewProvider {
    static var previews: some View {
        DelayedAppearView {
            Text("Hello, is it me you are looking for?")
        }
    }
}
