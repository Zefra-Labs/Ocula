//
//  SettingsLegalView.swift
//  Ocula
//
//  Created by Tyson Miles on 13/2/2026.
//

import SwiftUI
import SafariServices

struct SettingsLegalView: View {

    @State private var selectedLink: LegalLink?

    var body: some View {
        SettingsScaffold(title: "Legal Information") {
            SettingsList {
                Section(header: SettingsSectionHeader(title: "Legal Policies"), footer: Text("Understand what data and information the Ocula app collects by reading the Terms of Use and Privacy Policy.")
                    .font(.footnote)) {
                        actionRow(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            subtitle: "How your data is collected and used",
                            action: {
                                selectedLink = LegalLink(
                                    title: "Privacy Policy",
                                    url: URL(string: "https://milescomedia.com.au/legal/")!
                                )
                            },
                            style: .list
                        )
                    actionRow(
                        icon: "info.circle.text.page.fill",
                        title: "Terms of Service",
                        subtitle: "Terms, conditions, and acceptable use",
                        action: {
                            selectedLink = LegalLink(
                                title: "Terms of Service",
                                url: URL(string: "https://milescomedia.com.au/terms")!
                            )
                        },
                        style: .list
                    )
                }
                Section(header: SettingsSectionHeader(title: "Licence Information")) {
                        actionRow(
                            icon: "person.3.fill",
                            title: "Third-Party Licences",
                            subtitle: "",
                            action: {
                                selectedLink = LegalLink(
                                    title: "Privacy Policy",
                                    url: URL(string: "https://milescomedia.com.au/legal/")!
                                )
                            },
                            style: .list
                        )
                    actionRow(
                        icon: "checkmark.seal.text.page.fill",
                        title: "App Licence",
                        subtitle: "",
                        action: {
                            selectedLink = LegalLink(
                                title: "Privacy Policy",
                                url: URL(string: "https://milescomedia.com.au/legal/")!
                            )
                        },
                        style: .list
                    )
                }
                Section(header: SettingsSectionHeader(title: "Other Policies")) {
                        actionRow(
                            icon: "hand.raised.fill",
                            title: "Location Usage Disclosure",
                            subtitle: "How your data is collected and used",
                            action: {
                                selectedLink = LegalLink(
                                    title: "Privacy Policy",
                                    url: URL(string: "https://milescomedia.com.au/legal/")!
                                )
                            },
                            style: .list
                        )
                }
            }
        }
        .fullScreenCover(item: $selectedLink) { link in
            SafariView(url: link.url)
                .ignoresSafeArea()
        }
    }
}

private struct LegalLink: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

private struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    SettingsLegalView()
}
