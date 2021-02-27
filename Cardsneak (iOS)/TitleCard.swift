//
//  TitleCard.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/25/21.
//

import SwiftUI

struct TitleCard: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("♠️ ♦️")
                    .font(.footnote)
                    Text("Cardsneak")
                        .font(Font.system(size: 40, design: .rounded)
                                .weight(.bold))
                .shadow(radius: 2)
                Text("♥️ ♣️")
                    .font(.footnote)
            }.padding()
        }
    }
    
}
