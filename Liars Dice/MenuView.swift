//
//  MenuView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    @State private var numPlayers: Int = 4
    @State private var dicePerPlayer: Int = 5
    @FocusState private var playerFocus: Bool
    @FocusState private var diceFocus: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Liar's Dice")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image("twoDice")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250.0, height: 150.0)
                }
                
                VStack() {
                    Text("Dice per player")
                        .font(.subheadline)
                    TextField("Dice per player", value: $dicePerPlayer, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($playerFocus)
                        
                }
                .padding([.leading, .trailing], 90.0)
                .padding(.bottom)
                                
                VStack() {
                    Text("Number of players")
                        .font(.subheadline)
                    TextField("Dice per player", value: $numPlayers, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($diceFocus)
                        
                }
                .padding([.leading, .trailing], 90.0)
                .padding(.bottom)
                
                Button("Play") {
                    game.resetGame(numPlayers: numPlayers, dicePerPlayer: dicePerPlayer)
                    viewRouter.currentPage = .gamePage
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding()
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        playerFocus = false
                        diceFocus = false
                    }
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
            .previewInterfaceOrientation(.portrait)
    }
}
