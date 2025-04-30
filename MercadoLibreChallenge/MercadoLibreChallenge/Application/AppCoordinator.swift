//
//  AppCoordinator.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import Foundation
import UIKit

class AppCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewModel = SearchViewModel()
        let searchVC = SearchViewController(viewModel: searchViewModel)
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: false)
    }
    
    func showResults(for query: String) {
        let resultsViewModel = ResultsViewModel(query: query)
        let resultsVC = ResultsViewController(viewModel: resultsViewModel)
        resultsVC.coordinator = self
        navigationController.pushViewController(resultsVC, animated: true)
    }
    
    func showProductDetail(for itemId: String) {
        let detailViewModel = ProductDetailViewModel(itemId: itemId)
        let detailVC = ProductDetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
