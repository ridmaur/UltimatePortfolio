//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Rob In der Maur on 25/10/2020.
//

import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    // the all encompassing datacontroller
    @EnvironmentObject var dataController: DataController

    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}
