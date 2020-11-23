//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  This overrides the out of the box binding usng $ with more sophisticated
//  ways of handling changes and updating the UI accordingly
//
//
//  Created by Rob In der Maur on 30/10/2020.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
