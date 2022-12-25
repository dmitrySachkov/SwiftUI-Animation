//
//  ContentView.swift
//  SwiftUI Animation
//
//  Created by Dmitry Sachkov on 24.12.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
