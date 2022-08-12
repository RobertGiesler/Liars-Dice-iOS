//
//  Liars_DiceApp.swift
//  Liars Dice
//
//  Created by Robert Giesler on 06.08.22.
//

import SwiftUI

@main
struct Liars_DiceApp: App {
    @StateObject var viewRouter = ViewRouter()
    @StateObject var game = Game(numPlayers: 2)
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .environmentObject(viewRouter)
                .environmentObject(game)
        }
    }
}
