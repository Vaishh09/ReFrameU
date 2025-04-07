import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveReframe(text: String, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "User not logged in", code: 401))
            return
        }

        let data: [String: Any] = [
            "text": text,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("reframes").document(userId).collection("saved").addDocument(data: data, completion: completion)

        savePlantForReframe()
    }

    func fetchReframes(completion: @escaping ([String]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("reframes").document(userId).collection("saved")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch reframes:", error.localizedDescription)
                    completion([])
                    return
                }

                let reframes = snapshot?.documents.compactMap { $0.data()["text"] as? String } ?? []
                completion(reframes)
            }
    }

    func savePlantForReframe() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let plantTypes = ["🌱", "🌿", "🌷", "🌸", "🌼", "🪴", "🌳"]
        let randomType = plantTypes.randomElement() ?? "🌱"

        let data: [String: Any] = [
            "type": randomType,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("reframeIsland").document(userId).collection("plants").addDocument(data: data) { error in
            if let error = error {
                print("❌ Failed to save plant:", error.localizedDescription)
            } else {
                print("✅ Plant added to island: \(randomType)")
            }
        }
    }
    
    

    
    func saveMood(name: String, emoji: String, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let data: [String: Any] = [
            "name": name,
            "emoji": emoji,
            "timestamp": Timestamp(),
            "userId": uid
        ]
        
        db.collection("moods").addDocument(data: data) { error in
            completion?(error)
        }
    }
    
    
    
    func fetchMoodLogs(for userId: String, completion: @escaping ([String: String]) -> Void) {
        let logsRef = Firestore.firestore().collection("moodLogs").document(userId).collection("logs")
        logsRef.getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching mood logs: \(error.localizedDescription)")
                completion([:])
                return
            }

            var moodData: [String: String] = [:]
            for doc in snapshot?.documents ?? [] {
                let mood = doc.data()["mood"] as? String ?? "Unknown"
                moodData[doc.documentID] = mood
            }
            completion(moodData)
        }
    }

        
        
    }
