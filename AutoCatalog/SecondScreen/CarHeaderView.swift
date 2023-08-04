//
//  HeaderView.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit
import Kingfisher

class CarHeaderView: UIView {
    
    private let indent = Constraints.standardIndent
    private let midIndent = Constraints.midIndent
    private let smallIndent = Constraints.smallIndent
    private let imageHeight = Constraints.carImageSize
    private let avatarHeight = Constraints.avatarHeight
    
    private let headerMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Layers.standartCornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let carNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: FontSizes.standartTitle)
        return label
    }()
    
    private let carAttributesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSizes.carAttribute)
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = Layers.avatarCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: FontSizes.userName)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        [headerMainImageView, avatarImageView, userNameLabel, carNameLabel, carAttributesLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let imageHeightConstraint = headerMainImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        imageHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            headerMainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: indent),
            headerMainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: smallIndent),
            headerMainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -smallIndent),
            imageHeightConstraint,
            
            avatarImageView.topAnchor.constraint(equalTo: headerMainImageView.bottomAnchor, constant: midIndent),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: indent),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarHeight),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: indent),
            userNameLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            carNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -indent),
            
            carAttributesLabel.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: midIndent),
            carAttributesLabel.trailingAnchor.constraint(equalTo: carNameLabel.trailingAnchor),
            carAttributesLabel.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor)
        ])
    }
    
    public func configureHeaderView(carData: CarInfoDetail) {
        
        let car = carData.car
        let user = carData.user
        
        let carImagePath = car.images.first?.url ?? "Car image"
        let userImagePath = user.avatar.url

        carNameLabel.text = "\(car.brandName) \(car.modelName)"
        carAttributesLabel.text = "\(car.engine) \(car.transmissionName) \(car.year)"
        userNameLabel.text = user.username
        setImageWithOptions(carImagePath, headerMainImageView)
        setImageWithOptions(userImagePath, avatarImageView)
    }
    
    private func setImageWithOptions(_ imagePath: String, _ imageViewName: UIImageView) {
        let imageURL = URL(string: imagePath)
        
        imageViewName.kf.indicatorType = .activity
        imageViewName.kf.setImage(
            with: imageURL,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
