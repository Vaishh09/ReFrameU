import Foundation

struct ChatResponse: Codable {
    let response: String
}

class ChatbotAPI {
    static let shared = ChatbotAPI()

    func sendToReffie(_ message: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://reframeu.onrender.com/chat") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatRequest(message: message)

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown")
                return
            }

            do {
                let result = try JSONDecoder().decode(ChatResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.response)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
