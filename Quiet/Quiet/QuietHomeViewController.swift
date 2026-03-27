//
//  QuietHomeViewController.swift
//  Quiet
//
//  Minimal, calm home screen for the demo: one large Protection toggle and a
//  status line. Talks directly to the real on-device FirewallController,
//  deliberately bypassing the original tab-bar / upsell flow.
//

import UIKit
import NetworkExtension

final class QuietHomeViewController: UIViewController {

    private let titleLabel = UILabel()
    private let powerButton = UIButton(type: .custom)
    private let statusLabel = UILabel()
    private let detailLabel = UILabel()
    private let aboutButton = UIButton(type: .system)

    private let buttonSize: CGFloat = 168

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QuietTheme.background
        buildUI()
        NotificationCenter.default.addObserver(
            self, selector: #selector(vpnStatusChanged),
            name: .NEVPNStatusDidChange, object: nil)
        // Make sure there is something to block so the toggle can actually enable.
        if getIsCombinedBlockListEmpty() { setupFirewallDefaultBlockLists() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirewallController.shared.refreshManager { [weak self] _ in
            DispatchQueue.main.async { self?.updateUI() }
        }
        updateUI()
    }

    // MARK: - Layout

    private func buildUI() {
        titleLabel.text = "Quiet"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = QuietTheme.primaryText
        titleLabel.textAlignment = .center

        powerButton.layer.cornerRadius = buttonSize / 2
        powerButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            let cfg = UIImage.SymbolConfiguration(pointSize: 64, weight: .regular)
            powerButton.setImage(UIImage(systemName: "power", withConfiguration: cfg), for: .normal)
        } else {
            powerButton.setTitle("On", for: .normal)
            powerButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        }

        statusLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        statusLabel.textAlignment = .center

        detailLabel.font = .systemFont(ofSize: 15, weight: .regular)
        detailLabel.textColor = QuietTheme.secondaryText
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0

        aboutButton.setTitle("About", for: .normal)
        aboutButton.setTitleColor(QuietTheme.accent, for: .normal)
        aboutButton.addTarget(self, action: #selector(showAbout), for: .touchUpInside)

        for v in [titleLabel, powerButton, statusLabel, detailLabel, aboutButton] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            powerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            powerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            powerButton.widthAnchor.constraint(equalToConstant: buttonSize),
            powerButton.heightAnchor.constraint(equalToConstant: buttonSize),

            statusLabel.topAnchor.constraint(equalTo: powerButton.bottomAnchor, constant: 28),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            detailLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40),
            detailLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40),

            aboutButton.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -16),
            aboutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - State

    private func isActive(_ s: NEVPNStatus) -> Bool {
        return s == .connected || s == .connecting || s == .reasserting
    }

    private func updateUI() {
        let status = FirewallController.shared.status()
        let on = isActive(status)
        powerButton.backgroundColor = on ? QuietTheme.accent : QuietTheme.inactiveFill
        powerButton.tintColor = on ? .white : QuietTheme.accent

        switch status {
        case .connected:
            statusLabel.text = "Blocking ads"
            statusLabel.textColor = QuietTheme.accent
        case .connecting, .reasserting:
            statusLabel.text = "Starting…"
            statusLabel.textColor = QuietTheme.secondaryText
        case .disconnecting:
            statusLabel.text = "Stopping…"
            statusLabel.textColor = QuietTheme.secondaryText
        default:
            statusLabel.text = "Off"
            statusLabel.textColor = QuietTheme.secondaryText
        }

        let blocked = getTotalMetricsString()
        detailLabel.text = on
            ? "Ads and trackers are being blocked in all your apps.\n\(blocked) connections blocked so far."
            : "Tap to block ads and trackers across every app."
    }

    // MARK: - Actions

    @objc private func vpnStatusChanged() {
        DispatchQueue.main.async { [weak self] in self?.updateUI() }
    }

    @objc private func toggleTapped() {
        let status = FirewallController.shared.status()
        if isActive(status) {
            FirewallController.shared.setEnabled(false, isUserExplicitToggle: true) { [weak self] _ in
                DispatchQueue.main.async { self?.updateUI() }
            }
        } else {
            if getIsCombinedBlockListEmpty() { setupFirewallDefaultBlockLists() }
            FirewallController.shared.setEnabled(true, isUserExplicitToggle: true) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error { self?.presentError(error) }
                    self?.updateUI()
                }
            }
        }
        updateUI()
    }

    private func presentError(_ error: Error) {
        let alert = UIAlertController(
            title: "Couldn’t start protection",
            message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func showAbout() {
        present(UINavigationController(rootViewController: QuietAboutViewController()), animated: true)
    }
}

/// Tiny about screen with honest open-source attribution.
final class QuietAboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        view.backgroundColor = QuietTheme.background

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = QuietTheme.primaryText
        label.text = """
        Quiet is a proof-of-concept ad & tracker blocker.

        It blocks unwanted connections on-device with a local DNS firewall — no \
        traffic is sent to any server we run.

        This demo is built on the open-source, GPL-licensed Lockdown project as a \
        technology reference. See LICENSE.md for details.
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: g.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(close))
    }

    @objc private func close() { dismiss(animated: true) }
}
