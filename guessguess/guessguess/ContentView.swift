
import SwiftUI

struct SelectTypeView: View {
    @State private var selectedType: String = "True or False"
    @State private var selectedField: String = "Sports"
    @State private var showContentView = false

    let lightBlue = Color(red: 135/255, green: 206/255, blue: 250/255)
    let lavender = Color(red: 102/255, green: 208/255, blue: 255/255)

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [lightBlue, lavender]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Text("Select Question Type")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()

                    Picker("Type", selection: $selectedType) {
                        Text("Multiple Choice").tag("Multiple Choice")
                        Text("True or False").tag("True or False")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    
                    Picker("Field", selection: $selectedField) {
                         Text("Sports").tag("Sports")
                         Text("Politics").tag("Politics")
                         Text("Art").tag("Art")
                         Text("Animals").tag("Animals")
                     }
                     .pickerStyle(SegmentedPickerStyle())
                     .padding(.horizontal, 40)
                     .padding(.bottom, 80)
                    
                    Text("Trivia!")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    
                    Spacer()

                    Button(action: {
                        showContentView = true
                    }) {
                        Text("Start")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showContentView) {
                        ContentView(questionType: selectedType, questionField: selectedField)
                    }
                    .padding(.top, 20)
                    .padding(.bottom)
                }
                .padding()
            }
        }
    }
}




struct ContentView: View {
    let questionType: String
    let questionField: String
    // The dog's breed
    @State var dogBreed: String = ""
    // URL of image from API call
    @State var imageURL: String = ""
    // User's input
    @State var user_guess: String = ""
    // User's best streak
    @State var best_streak: Int = 0
    // User's streak for the current run
    @State var streak: Int = 0
    // True when user has made an incorrect guess, false otherwise.
    @State var incorrectGuess: Bool = false
    
    @State var question: String = ""
    @State var correct: String = ""
    @State var incorrect: [String] = [""]
    @State var choices: [String] = []
    @State var diff: String = "Easy"
    
    // Colors!
    let lightBlue = Color(red: 135/255, green: 206/255, blue: 250/255)
    let lavender = Color(red: 102/255, green: 208/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            // Gradient in background
            LinearGradient(gradient: Gradient(colors: [lightBlue, lavender]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .padding(.top, 60)
            // VStack in foreground
            VStack {
                
                Text("Trivia!")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Text("Streak: \(streak)")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Best Streak: \(best_streak)")
                        .foregroundColor(.white)
                }.padding(.bottom, 20)
                
                Text("Your current difficulty is: \(diff)")
                
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                Text("\(question)")
                
                // Load the image of the dog asyncronously.
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 256, height: 256)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 256, height: 256)
                
                VStack {
                    ForEach(choices, id: \.self) { choice in
                        Button(action: {
                            if (choice == correct) {
                                streak += 1
                                best_streak = max(best_streak, streak)
                                
                                if (streak == 5 && diff == "Easy") {
                                    diff = "Medium"
                                    streak = 0
                                    
                                } else if (streak == 5 && diff == "Medium") {
                                    diff = "Hard"
                                    streak = 0
                                }
                                
                                Task {
                                    let newDog = await fetchDoggy()
                                    imageURL = newDog.message
                                    dogBreed = getDogName(imageURL: newDog.message)
                                    
                                    let newQuestion = await fetchRandomQuizQuestion(input: diff, type: questionType, fi: questionField)
                                    question = newQuestion.question
                                    correct = newQuestion.correctAnswer
                                    incorrect = newQuestion.incorrectAnswers
                                    choices = incorrect + [correct]
                                    choices.shuffle()
                                }
                            } else {
                                incorrectGuess.toggle()
                            }
                            
                            // Clear guess
                            user_guess = ""
                        }, label: {
                            Text(choice)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        })
                        .padding(.vertical, 5)
                    }
                    
                    // Submit Guess
                    Button("Submit Guess") {
                        // Increment score by 1 and update high score.
                        if (user_guess.lowercased() == dogBreed.lowercased()) {
                            // Update streak
                            streak += 1
                            best_streak = max(best_streak, streak)
                            
                            
                            // Get new dog here, so they can still see dog in background after losing.
                            Task {
                                let newDog = await fetchDoggy()
                                dogBreed = getDogName(imageURL: newDog.message)
                                imageURL = newDog.message
                            }
                            
                            Task {
                                let n = await fetchRandomQuizQuestion(input:diff, type: questionType,
                                fi: questionField)
                                question = n.question
                                correct = n.correctAnswer
                                incorrect = n.incorrectAnswers
                                choices = incorrect + [correct]
                                choices.shuffle()
                            }
                        } else {
                            incorrectGuess.toggle()
                        }
                        
                        // Clear guess
                        user_guess = ""
                    }
                    .padding()
                    .alert("Wrong choice!", isPresented: $incorrectGuess) {
                        Button("Play Again", role: .cancel) {
                            // Reset streak
                            streak = 0
                            
                            // Get a new dog
                            Task {
                                let newDog = await fetchDoggy()
                                imageURL = newDog.message
                                dogBreed = getDogName(imageURL: newDog.message)
                            }
                            
                            Task {
                                let n = await fetchRandomQuizQuestion(input: diff, type: questionType, fi: questionField)
                                question = n.question
                                correct = n.correctAnswer
                                incorrect = n.incorrectAnswers
                                choices = incorrect + [correct]
                                choices.shuffle()
                            }
                        }
                    } message: {
                        Text("It was \(correct)!\nYour streak was: \(streak)")
                    }
                    
                    Spacer()
                    Spacer()
                    
                    // Answer for debugging/testing purposes.
                }
                .task {
                    // Get dog upon loading the app.
                    let newDog = await fetchDoggy()
                    dogBreed = getDogName(imageURL: newDog.message)
                    imageURL = newDog.message
                    
                    let n = await fetchRandomQuizQuestion(input: diff, type: questionType, fi: questionField)
                    question = n.question
                    correct = n.correctAnswer
                    incorrect = n.incorrectAnswers
                    choices = incorrect + [correct]
                    choices.shuffle()
                }
            }
        }
    }
    
}
