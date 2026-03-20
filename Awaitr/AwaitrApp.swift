//
//  AwaitrApp.swift
//  Awaitr
//
//  Created by ZoldyckD on 20/03/26.
//

import SwiftUI
import SwiftData

@main
struct AwaitrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WaitItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        NotificationService.registerCategories()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
