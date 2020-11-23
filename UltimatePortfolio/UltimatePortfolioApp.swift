//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Rob In der Maur on 25/10/2020.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                
                // when we do receive a notification that the app is pushed to the background
                // ensure we save the status
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
            
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
