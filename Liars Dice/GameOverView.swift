//
//  GameOverView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 21.08.22.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    var message: String {
        if game.winner {
            return "Winner!"
        }
        else {
            return "I'm out :("
        }
    }
    
    var body: some View {
        VStack {
            Text(message)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Button() {
                viewRouter.currentPage = .menuPage
            } label: {
                Text("Return home")
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
    }
}
