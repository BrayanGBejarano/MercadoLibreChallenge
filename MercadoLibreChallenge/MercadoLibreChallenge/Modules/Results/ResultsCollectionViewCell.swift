//
//  ResultsCollectionViewCell.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "ResultsCollectionViewCell"
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 6
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .mlPrimary
        return label
    }()
    
    private lazy var freeShippingTag: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .mlGreen
        label.text = "Envío gratis"
        label.layer.cornerRadius = 4
        label.layer.borderColor = UIColor.mlGreen.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(textStack)
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(priceLabel)
        textStack.addArrangedSubview(freeShippingTag)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            
            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            textStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),
            
            freeShippingTag.heightAnchor.constraint(equalToConstant: 18),
            freeShippingTag.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Configuration
    func configure(with item: Item) {
        titleLabel.text = item.title
        priceLabel.text = item.formattedPrice
        imageView.loadImage(from: URL(string: item.thumbnail))
        freeShippingTag.isHidden = !item.acceptsMercadopago
        
        if UIScreen.main.bounds.width <= 320 {
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        freeShippingTag.isHidden = true
    }
}
