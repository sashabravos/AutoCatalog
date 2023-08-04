//
//  HeaderView.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit
import Kingfisher

class CarHeaderView: UIView {
    
    private let headerMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let carNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let carAttributesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
        
        let imageHeightConstraint = headerMainImageView.heightAnchor.constraint(equalToConstant: 250)
        imageHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            headerMainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            headerMainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            headerMainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            imageHeightConstraint,
            
            avatarImageView.topAnchor.constraint(equalTo: headerMainImageView.bottomAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            userNameLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            carNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            carAttributesLabel.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 8),
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
