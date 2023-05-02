//
//  Dog.swift
//  guessguess
//
//  Created by 屈宸毅 on 5/1/23.
//

import Foundation

/* This is a model or "blueprint" for the JSON data that we will receive from the api! */
struct Dog: Codable {
    let message: String
    let status: String
}

struct QuizResponse: Codable {
    let responseCode: Int
    let results: [QuizQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct QuizQuestion: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

