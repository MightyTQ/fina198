//
//  HelperFunctions.swift
//  guessguess
//
//  Created by 屈宸毅 on 5/1/23.
//

import Foundation

func getDogName(imageURL: String) -> String {
    let dogName = imageURL.split(separator: "/")[3]
    if (dogName.contains("-")) {
        let split = dogName.split(separator: "-")
        return "\(split[0])"
    }
    return String(dogName)
}

