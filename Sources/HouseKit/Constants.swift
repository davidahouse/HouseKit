//
//  Constants.swift
//  francis
//
//  Created by David House on 8/1/20.
//

import Foundation

public enum Constants {
    public static let iso8601Full: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter
    }()
}
