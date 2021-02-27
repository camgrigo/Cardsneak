//
//  PlayersEditor.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/26/21.
//

import SwiftUI

struct PlayersEditor: View {
    @Binding var players: [Player]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                    ForEach(players, id: \.id) { player in
//                        HStack {
//                            //                        TextField("Name", text: player.name)
                            Text(player.name)
//                        StylizedTextField(title: "Player name", text: $name).padding()
//                            Spacer()
//                            if player is UserPlayer {
//                                Image(systemName: "person.fill")
//                            }
//                        }
                    }
            }
        }
    }
}

//struct PlayersEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayersEditor()
//    }
//}
