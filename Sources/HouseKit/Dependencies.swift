//
//  Dependencies.swift
//  francis
//
//  Created by David House on 8/1/20.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension View {
 
    #if DEBUG
    func previewDependencies() -> some View {
        return self
    }
    #endif
}
