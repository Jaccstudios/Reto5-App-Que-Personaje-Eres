import SwiftUI

// MARK: - Modelos de Datos
struct Question {
    let text: String
    let options: [Answer]
}

struct Answer {
    let text: String
    let character: String
}

struct ContentView: View {
    // MARK: - Colecciones
    let questions: [Question] = [
        Question(text: "¿Qué prefieres hacer en tu tiempo libre?", options: [
            Answer(text: "Construir o desarmar cosas electrónicas.", character: "Tony Stark (Iron Man)"),
            Answer(text: "Leer sobre estrategias e historia.", character: "Steve Rogers (Capitán América)"),
            Answer(text: "Investigar en el laboratorio de ciencias.", character: "Bruce Banner (Hulk)")
        ]),
        Question(text: "¿Cómo resuelves un problema difícil?", options: [
            Answer(text: "Uso la última tecnología disponible.", character: "Tony Stark (Iron Man)"),
            Answer(text: "Organizo a mi equipo y trazamos un plan.", character: "Steve Rogers (Capitán América)"),
            Answer(text: "Analizo los datos hasta encontrar la solución.", character: "Bruce Banner (Hulk)")
        ]),
        Question(text: "¿Qué cualidad valoras más?", options: [
            Answer(text: "La innovación y el ingenio.", character: "Tony Stark (Iron Man)"),
            Answer(text: "La lealtad y el honor.", character: "Steve Rogers (Capitán América)"),
            Answer(text: "El conocimiento y la paciencia.", character: "Bruce Banner (Hulk)")
        ]),
        Question(text: "¿Cuál sería tu herramienta ideal de trabajo?", options: [
            Answer(text: "Una inteligencia artificial avanzada.", character: "Tony Stark (Iron Man)"),
            Answer(text: "Un escudo irrompible.", character: "Steve Rogers (Capitán América)"),
            Answer(text: "Un microscopio de alta potencia.", character: "Bruce Banner (Hulk)")
        ]),
        Question(text: "¿Cómo prefieres trabajar?", options: [
            Answer(text: "A mi propio ritmo, probando cosas.", character: "Tony Stark (Iron Man)"),
            Answer(text: "Liderando y motivando a un grupo.", character: "Steve Rogers (Capitán América)"),
            Answer(text: "En un ambiente tranquilo y controlado.", character: "Bruce Banner (Hulk)")
        ])
    ]
    
    // MARK: - Variables de Estado
    @State private var scores: [String: Int] = [
        "Tony Stark (Iron Man)": 0,
        "Steve Rogers (Capitán América)": 0,
        "Bruce Banner (Hulk)": 0
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var isFinished = false
    @State private var finalCharacter = ""
    @State private var characterDescription = ""
    
    var body: some View {
        ZStack {
            // Fondo con degradado moderno
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.4, green: 0.2, blue: 0.6)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if isFinished {
                    resultView
                        .transition(.scale.combined(with: .opacity))
                } else {
                    questionView
                        // Transición de deslizamiento al cambiar de pregunta
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        // El .id fuerza a SwiftUI a tratar cada pregunta como una vista nueva para animarla
                        .id(currentQuestionIndex)
                }
            }
        }
    }
    
    // MARK: - Vista de Preguntas
    var questionView: some View {
        VStack(spacing: 20) {
            // Barra de progreso y contador
            VStack(spacing: 8) {
                Text("Pregunta \(currentQuestionIndex + 1) de \(questions.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))
                
                ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .padding(.horizontal, 40)
            }
            .padding(.top, 30)
            
            Spacer()
            
            // Tarjeta de la pregunta principal
            VStack(spacing: 30) {
                Text(questions[currentQuestionIndex].text)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Botones de respuesta
                VStack(spacing: 15) {
                    ForEach(questions[currentQuestionIndex].options, id: \.text) { option in
                        Button(action: {
                            // Animación al hacer clic
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                                selectAnswer(option)
                            }
                        }) {
                            Text(option.text)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(15)
                                .shadow(color: .blue.opacity(0.4), radius: 5, x: 0, y: 5)
                        }
                    }
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
            .padding(.horizontal, 25)
            
            Spacer()
        }
    }
    
    // MARK: - Vista de Resultados
    var resultView: some View {
        VStack(spacing: 25) {
            Image(systemName: "sparkles")
                .font(.system(size: 70))
                .foregroundColor(.yellow)
                .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Text("¡Análisis Completado!")
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
            
            Text("Tu personaje es:")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(finalCharacter)
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
            
            Text(characterDescription)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                .padding(.horizontal, 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .padding(.horizontal, 30)
                )
        }
        .padding()
    }
    
    // MARK: - Lógica de la Aplicación
    func selectAnswer(_ answer: Answer) {
        scores[answer.character, default: 0] += 1
        
        if currentQuestionIndex == questions.count - 1 {
            calculateResult()
            isFinished = true
        } else {
            currentQuestionIndex += 1
        }
    }
    
    func calculateResult() {
        var maxScore = -1
        var winningCharacter = ""
        
        for (character, score) in scores {
            if score > maxScore {
                maxScore = score
                winningCharacter = character
            }
        }
        
        finalCharacter = winningCharacter
        
        switch finalCharacter {
        case "Tony Stark (Iron Man)":
            characterDescription = "Eres un genio, innovador y te encanta la tecnología. Confías en tu intelecto para resolver cualquier problema."
        case "Steve Rogers (Capitán América)":
            characterDescription = "Eres un líder natural, valoras la ética, la lealtad y siempre pones a tu equipo primero."
        case "Bruce Banner (Hulk)":
            characterDescription = "Eres una mente brillante y analítica. Prefieres pensar las cosas a fondo y basarte en la ciencia."
        default:
            characterDescription = "Tienes el potencial de un gran héroe."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
