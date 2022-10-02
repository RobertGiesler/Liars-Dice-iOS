//
//  RevealView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI

struct DiceOnTableView: View {
    let diceArray: [Int]
    
    var body: some View {
        let fullRows: Int = diceArray.count / 3
        let diceInLastRow: Int = diceArray.count % 3
        
        VStack {
            var dice: [Int] = diceArray
            
            ForEach(0..<fullRows, id: \.self) { row in
                HStack {
                    ForEach(0..<3) { column in
                        let die = dice.removeFirst()
                        Image("Face\(die)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(maxHeight: 105)
            }
            
            HStack {
                ForEach(0..<diceInLastRow, id: \.self) { column in
                    let die = dice.removeFirst()
                    Image("Face\(die)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(maxHeight: 105)
        }
    }
}

struct RevealView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
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
        VStack {
            HStack {
                Spacer()
                
                Button() {
                    viewRouter.currentPage = .menuPage
                } label: {
                    Image(systemName: "house")
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
            
            DiceOnTableView(diceArray: diceArray)
            
            HStack {
                Button(role: .destructive) {
                    game.nextRound(loseDie: true)
                    if game.dice.count > 0 {
                        viewRouter.currentPage = .gamePage
                    }
                    else {
                        game.winner = false
                        viewRouter.currentPage = .gameOverPage
                    }
                } label: {
                    Text("Lose die")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button() {
                    game.nextRound(loseDie: false)
                    if game.dice.count != game.numTotalDice {
                        viewRouter.currentPage = .gamePage
                    }
                    else {
                        game.winner = true
                        viewRouter.currentPage = .gameOverPage
                    }
                } label: {
                    Text("Keep die")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
            }
            .padding([.leading, .trailing], 60.0)
            .padding(.top)
            
            Spacer()
            
            Button() {
                viewRouter.currentPage = .gamePage
            } label: {
                Text("Hide dice")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding([.leading, .trailing], 60.0)
            
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
