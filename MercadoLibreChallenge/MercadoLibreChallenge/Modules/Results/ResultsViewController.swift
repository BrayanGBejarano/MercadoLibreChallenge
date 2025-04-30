//
//  ResultsViewController.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit

final class ResultsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: ResultsViewModel
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: ResultsCollectionViewCell.identifier)
        cv.backgroundColor = .systemGroupedBackground
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
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
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.configure(
            image: UIImage(named: "search_empty"),
            title: "No se encontraron resultados".localized,
            description: "Intenta con otra búsqueda".localized
        )
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: ResultsViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Resultados".localized
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupBindings() {
            viewModel.itemsObservable.bind { [weak self] items in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
            viewModel.isLoading.bind { [weak self] isLoading in
                DispatchQueue.main.async {
                    isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                }
            }
            
            viewModel.showEmptyState.bind { [weak self] show in
                DispatchQueue.main.async {
                    self?.emptyStateView.isHidden = !show
                }
            }
            
            viewModel.error.bind { [weak self] error in
                guard let error = error else { return }
                DispatchQueue.main.async {
                    self?.showError(error) { [weak self] in
                        self?.viewModel.retryLastSearch()
                    }
                }
            }
        }
}

// MARK: - CollectionView DataSource & Delegate
extension ResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ResultsCollectionViewCell.identifier,
            for: indexPath
        ) as? ResultsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension ResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        coordinator?.showProductDetail(for: item.id)
    }
}

extension ResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let availableWidth = view.frame.width - padding
        let widthPerItem = availableWidth / 2 - 8
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
}

