//
//  Sleep_Time_AppApp.swift
//  Sleep Time App
//
//  Created by Dayanna Calderon on 2/7/23.
//

import SwiftUI

@main
struct Sleep_Time_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
