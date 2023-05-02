import Foundation

/* Returns a Dog optional type from calling the dogAPI and decoding the fetched JSON.
 
 Ex1 fetchDog() is able to get a valid response from API: fetchDog() -> Dog
 Ex2 fetchDog() is NOT able to get a valid response from API: fetchDog() -> nil
 */
func fetchDog() async -> Dog? {
    // Define url
    guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
        return nil
    }
    
    // Wrap api call inside a do/catch block in case an error is thrown.
    do {
        // Get data (the second item (URLResponse) we don't need so we'll just assign it to _).
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode JSON into a Dog struct.
        if let decodedResponse = try? JSONDecoder().decode(Dog.self, from: data) {
            return decodedResponse
        }
    } catch {
        // Handle api call error here.
        return nil
    }
    return nil
}


/* Continuously calls fetchDog() until a Dog is returned and returns that Dog. */
func fetchDoggy() async -> Dog {
    // Try to get a Dog
    var newDog = (await fetchDog()) ?? nil
    
    // Check if there is a Dog
    while (newDog == nil) {
        // Try again to get Dog
        newDog = (await fetchDog()) ?? nil
    }
    
    // Can force-unwrap because newDog is guaranteed a dog.
    return newDog!
}


func fetchQuizQuestion(input: String, type: String, fi: String) async -> QuizQuestion? {
    // Define url
    let urlString: String
    
    let categoryMapping: [String: String] = [
        "Sports": "21",
        "Politics": "24",
        "Art": "25",
        "Animals": "27"
    ]
    guard let category = categoryMapping[fi] else {
            return nil
        }
    
    if type == "Multiple Choice" {
        if input == "Easy" {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=easy&type=multiple"
        } else if input == "Median" {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=medium&type=multiple"
        } else {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=hard&type=multiple"
        }
    } else {
        if input == "Easy" {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=easy&type=boolean"
        } else if input == "Median" {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=medium&type=boolean"
        } else {
            urlString = "https://opentdb.com/api.php?amount=1&category=\(category)&difficulty=hard&type=boolean"
        }
    }

    guard let url = URL(string: urlString) else {
        return nil
    }
    
    // Wrap api call inside a do/catch block in case an error is thrown.
    do {
        // Get data (the second item (URLResponse) we don't need so we'll just assign it to _).
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode JSON into a QuizQuestion struct.
        if let decodedResponse = try? JSONDecoder().decode(QuizResponse.self, from: data) {
            return decodedResponse.results.first
        }
    } catch {
        // Handle api call error here.
        return nil
    }
    return nil
}


/* Continuously calls fetchQuizQuestion() until a QuizQuestion is returned and returns that QuizQuestion. */
func fetchRandomQuizQuestion(input: String, type:String, fi:String) async -> QuizQuestion {
    // Try to get a QuizQuestion
    var newQuestion = (await fetchQuizQuestion(input: input, type: type, fi: fi)) ?? nil
    
    // Check if there is a QuizQuestion
    while (newQuestion == nil) {
        // Try again to get QuizQuestion
        newQuestion = (await fetchQuizQuestion(input: input, type: type, fi: fi)) ?? nil
    }
    
    // Can force-unwrap because newQuestion is guaranteed a QuizQuestion.
    return newQuestion!
}



