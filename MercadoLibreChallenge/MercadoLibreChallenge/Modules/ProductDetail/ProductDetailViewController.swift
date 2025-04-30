//
//  ProductDetailViewController.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: ProductDetailViewModel
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageCarousel: ImageCarouselView = {
        let view = ImageCarouselView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .mlPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(viewModel: ProductDetailViewModel) {
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
        bindViewModel()
        viewModel.fetchProductDetails()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Detalle del producto".localized
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageCarousel,
            titleLabel,
            priceLabel,
            conditionLabel,
            descriptionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func bindViewModel() {
        viewModel.product.bind { [weak self] product in
            DispatchQueue.main.async {
                guard let product = product else { return }
                self?.configure(with: product)
            }
        }
        
        viewModel.error.bind { [weak self] error in
            DispatchQueue.main.async {
                guard let error = error else { return }
                self?.showError(error) { [weak self] in
                    self?.viewModel.fetchProductDetails()
                }
            }
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        }
    }
    
    private func configure(with item: ItemDetail) {
        titleLabel.text = item.title
        priceLabel.text = item.formattedPrice
        conditionLabel.text = "Condición: \(item.conditionDisplay)"
        descriptionLabel.text = item.description ?? "No hay descripción disponible".localized
        
        let imageUrls = item.pictures.compactMap { URL(string: $0.secureUrl) }
        imageCarousel.configure(with: imageUrls, placeholder: UIImage(named: "product_placeholder"))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        imageCarousel.updateLayoutForRotation()
    }
}
