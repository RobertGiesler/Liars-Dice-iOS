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
    
    private var dicePerRow: [Int] {
        if game.dice.count % 2 == 0 {
            return Array(repeating: game.dice.count/2, count: 2)
        }
        else {
            let num = Int((Double(game.dice.count)/2.0).rounded(.up))
            return [num-1, num]
        }
    }
    
    // Returns Array of current dice in order, e.g. [1,1,3,4,6]
    private var diceArray: [Int] {
        let dice = game.getDiceValues()
        var result: [Int] = []
        var face: Int = 1
        
        for n in dice {
            for _ in 0..<n {
                result.append(face)
            }
            face += 1
        }
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack {
                var dice: [Int] = diceArray
                ForEach(0..<2) { row in
                    HStack {
                        ForEach(0..<dicePerRow[row]) { column in
                            let die = dice.removeFirst()
                            Image("Face\(die)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(maxHeight: 100)
                }
                
                HStack {
                    Button("Lose die", role: .destructive) {
                        game.nextRound(loseDie: true)
                        if game.dice.count > 0 {
                            viewRouter.currentPage = .gamePage
                        }
                        else {
                            
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Keep die") {
                        game.nextRound(loseDie: false)
                        if game.dice.count > 0 {
                            viewRouter.currentPage = .gamePage
                        }
                        else {
                            
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
            }
            .padding(.horizontal)
        }
    }
}

struct RevealView_Previews: PreviewProvider {
    static var previews: some View {
        RevealView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
    }
}
