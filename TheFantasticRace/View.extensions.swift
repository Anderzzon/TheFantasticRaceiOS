//
//  View.extensions.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-01.
//

import SwiftUI

// Boilerplate code to instatiate view
struct View_extensions: View {
    var body: some View {
        EmptyView()
    }
}

// MARK: Extention to print values within view hierarchy
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

//MARK: Extension for localization
extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}

//MARK: Hide keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

