//
//  RevealView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI

struct RevealView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RevealView_Previews: PreviewProvider {
    static var previews: some View {
        RevealView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
    }
}
