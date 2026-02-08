//
//  SessionManager.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//


import FirebaseAuth
import FirebaseFirestore
import Combine

final class SessionManager: ObservableObject {

    @Published var user: AppUser?
    @Published var isLoading = true

    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        listen()
    }

    private func listen() {
        listener = auth.addStateDidChangeListener { _, firebaseUser in
            guard let firebaseUser else {
                self.user = nil
                self.isLoading = false
                return
            }

            self.fetchUser(uid: firebaseUser.uid)
        }
    }

    private func fetchUser(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.user = try? snapshot?.data(as: AppUser.self)
            }
            self.isLoading = false
        }
    }

    func refreshUser() {
        guard let uid = auth.currentUser?.uid else { return }
        fetchUser(uid: uid)
    }

    func signOut() {
        try? auth.signOut()
        user = nil
    }
}
