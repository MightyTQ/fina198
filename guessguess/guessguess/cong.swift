//
//  cong.swift
//  guessguess
//
//  Created by 屈宸毅 on 5/1/23.
//

import Foundation
import SwiftUI

struct CongratulationsView: View {
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle)
            Text("You have reached a streak of 10!")
                .font(.title)
        }
    }
}

struct CongratulationsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationsView()
    }
}

