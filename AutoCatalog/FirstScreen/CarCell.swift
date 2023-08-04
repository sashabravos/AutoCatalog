//
//  CarCell.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit
import Kingfisher

final class CarCell: UITableViewCell {
    
    static let identifier = "CarCell"
    
    private let indent = Constraints.standardIndent
    private let imageHeight = Constraints.carImageSize
    private let titleHeight = Constraints.titleHeight
    
    private var cardImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: FontSizes.standartTitle)
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.layer.cornerRadius = Layers.standartCornerRadius
        stackView.backgroundColor = .white
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        [cardImage, titleLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageHeightConstraint = cardImage.heightAnchor.constraint(equalToConstant: imageHeight)
        imageHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent),

            imageHeightConstraint,
            cardImage.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            titleLabel.heightAnchor.constraint(equalToConstant: titleHeight)
        ])
    }
    
    public func configure(imageURL: URL?, title: String) {
        self.selectionStyle = .none
        self.backgroundColor = Colors.veryLightGray
        
        titleLabel.text = title
        
        let processor = RoundCornerImageProcessor(cornerRadius: Layers.smallCornerRadius,
                                                  roundingCorners: [.topLeft, .topRight])
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(
            with: imageURL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
