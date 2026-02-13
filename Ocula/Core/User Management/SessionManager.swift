//
//  SessionManager.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//


import FirebaseAuth
import FirebaseFirestore
import Combine
import SwiftUI

final class SessionManager: ObservableObject {
    
    @Published var user: AppUser?
    @Published var shouldDeferMainView = false
    @Published var showSignOutOverlay = false
    @Published var showSignOutSuccess = false
    @State var ShowSigningOutNotification: Bool = false
    @State var ShowSignedOutSuccessNotification: Bool = false
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
                self.shouldDeferMainView = false
                self.isLoading = false
                return
            }

            self.fetchUser(firebaseUser: firebaseUser)
        }
    }

    private func fetchUser(firebaseUser: User) {
        let uid = firebaseUser.uid
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let snapshot, snapshot.exists, let decoded = try? snapshot.data(as: AppUser.self) {
                self.user = decoded
                self.isLoading = false
                return
            }

            let fallbackUser = AppUser(
                id: uid,
                email: firebaseUser.email ?? "",
                displayName: firebaseUser.displayName ?? "Driver",
                createdAt: firebaseUser.metadata.creationDate ?? Date(),
                lastLogin: Date(),
                accountType: "standard",
                onboardingComplete: false,
                driverNickname: nil,
                vehicleNickname: nil,
                vehiclePlate: nil,
                vehicleBrand: nil,
                vehicleColorHex: nil
            )

            self.user = fallbackUser

            try? self.db.collection("users")
                .document(uid)
                .setData(from: fallbackUser, merge: true)

            self.isLoading = false
        }
    }
    
    func refreshUser() {
        guard let uid = auth.currentUser?.uid else { return }
        if let firebaseUser = auth.currentUser {
            fetchUser(firebaseUser: firebaseUser)
        }
    }
    
    func signOut(completion: ((Bool) -> Void)? = nil) {
        showSignOutOverlay = true
        do {
            try auth.signOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showSignOutOverlay = false
                self.showSignOutSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.showSignOutSuccess = false
                    self.user = nil
                    completion?(true)
                }
            }
        } catch {
            showSignOutOverlay = false
            completion?(false)
        }
    }
}
