//
//  MotherView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    var body: some View {
        switch viewRouter.currentPage {
        case .menuPage:
            MenuView()
        case .gamePage:
            GameView()
        case .revealPage:
            RevealView()
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
    }
}
