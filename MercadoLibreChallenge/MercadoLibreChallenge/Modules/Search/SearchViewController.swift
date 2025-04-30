//
//  SearchViewController.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SearchViewModel
    weak var coordinator: AppCoordinator?
    private let suggestionService = SuggestionService()
    private var suggestedProducts: [SuggestedProduct] = []
    private var lastContentOffset: CGPoint = .zero
    
    // MARK: - UI Components
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Buscar en MercadoLibre"
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = .mlPrimary
        sc.searchBar.delegate = self
        return sc
    }()
    
    private lazy var suggestionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Productos populares"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .mlDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var suggestionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ProductSuggestionCell.self, forCellWithReuseIdentifier: ProductSuggestionCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .mlPrimary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadSuggestedProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !suggestedProducts.isEmpty {
            suggestionsCollectionView.setContentOffset(lastContentOffset, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastContentOffset = suggestionsCollectionView.contentOffset
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToInitialPosition()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Buscar"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(suggestionsTitleLabel)
        view.addSubview(suggestionsCollectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            suggestionsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            suggestionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            suggestionsCollectionView.topAnchor.constraint(equalTo: suggestionsTitleLabel.bottomAnchor, constant: 12),
            suggestionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            suggestionsCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self?.showError(error) { [weak self] in
                    self?.searchController.searchBar.text.map {
                        self?.viewModel.search(query: $0)
                    }
                }
            }
        }
        
        viewModel.shouldNavigateToResults.bind { [weak self] query in
            guard let query = query else { return }
            DispatchQueue.main.async {
                self?.coordinator?.showResults(for: query)
            }
        }
    }
    
    private func loadSuggestedProducts() {
        guard suggestedProducts.isEmpty else { return }
        
        suggestionService.fetchPopularProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.suggestedProducts = products
                    self?.suggestionsCollectionView.reloadData()
                    self?.scrollToInitialPosition()
                case .failure(let error):
                    print("Error loading suggestions: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scrollToInitialPosition() {
        guard !suggestedProducts.isEmpty, lastContentOffset == .zero else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let middleIndex = self.suggestedProducts.count
            let indexPath = IndexPath(item: middleIndex, section: 0)
            
            if middleIndex < self.suggestionsCollectionView.numberOfItems(inSection: 0) {
                self.suggestionsCollectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
                self.lastContentOffset = self.suggestionsCollectionView.contentOffset
            }
        }
    }
}

// MARK: - CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedProducts.isEmpty ? 0 : suggestedProducts.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductSuggestionCell.identifier,
            for: indexPath
        ) as? ProductSuggestionCell else {
            return UICollectionViewCell()
        }
        
        let product = suggestedProducts[indexPath.row % suggestedProducts.count]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard !suggestedProducts.isEmpty else { return }
        
        let layout = suggestionsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                         y: -scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !suggestedProducts.isEmpty else { return }
        
        let layout = suggestionsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        
        if offsetX > contentWidth - scrollView.frame.width {
            let newOffset = offsetX - CGFloat(suggestedProducts.count) * cellWidthIncludingSpacing
            scrollView.contentOffset = CGPoint(x: newOffset, y: 0)
        } else if offsetX < 0 {
            let newOffset = contentWidth - scrollView.frame.width - cellWidthIncludingSpacing
            scrollView.contentOffset = CGPoint(x: newOffset, y: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = suggestedProducts[indexPath.row % suggestedProducts.count]
        coordinator?.showProductDetail(for: product.id)
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            return
        }
        viewModel.search(query: query)
    }
}
