//
//  UIViewController+Alerts.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit

extension UIViewController {
    // MARK: - Basic Alert
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        if let actions = actions, !actions.isEmpty {
            actions.forEach { alertController.addAction($0) }
        } else {
            let okAction = UIAlertAction(
                title: "OK".localized,
                style: .default
            )
            alertController.addAction(okAction)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  self.isViewLoaded && self.view.window != nil else {
                return
            }
            self.present(alertController, animated: true)
        }
    }
    
    // MARK: - Error Alert
    func showError(_ error: Error, retryHandler: (() -> Void)? = nil) {
        let message: String
        
        switch error {
        case let apiError as APIError:
            message = apiError.localizedDescription
        case let urlError as URLError where urlError.code == .notConnectedToInternet:
            message = "No hay conexión a Internet".localized
        default:
            message = error.localizedDescription
        }
        
        var actions = [UIAlertAction]()
        
        let okAction = UIAlertAction(
            title: "OK".localized,
            style: .default
        )
        actions.append(okAction)
        
        if let retryHandler = retryHandler {
            let retryAction = UIAlertAction(
                title: "Reintentar".localized,
                style: .default,
                handler: { _ in retryHandler() }
            )
            actions.append(retryAction)
        }
        
        showAlert(
            title: "Error".localized,
            message: message,
            actions: actions
        )
    }
    
    // MARK: - Loading Indicator
    private var loadingIndicatorTag: Int { return 9999 }
    
    func showLoadingIndicator(style: UIActivityIndicatorView.Style = .large,
                            backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        hideLoadingIndicator()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let loadingView = UIView(frame: self.view.bounds)
            loadingView.backgroundColor = backgroundColor
            loadingView.tag = self.loadingIndicatorTag
            loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.center = loadingView.center
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            loadingView.addSubview(activityIndicator)
            self.view.addSubview(loadingView)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            ])
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.subviews.forEach { subview in
                if subview.tag == self.loadingIndicatorTag {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Advanced Loading State (Opcional)
    func setLoadingState(_ isLoading: Bool,
                       style: UIActivityIndicatorView.Style = .large,
                       backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        isLoading ? showLoadingIndicator(style: style, backgroundColor: backgroundColor)
                 : hideLoadingIndicator()
    }
}
