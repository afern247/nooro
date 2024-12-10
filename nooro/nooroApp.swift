//
//  nooroApp.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

@main
struct nooroApp: App {
    var body: some Scene {
        WindowGroup {
            SessionView()
                .preferredColorScheme(.light)
        }
    }
}
