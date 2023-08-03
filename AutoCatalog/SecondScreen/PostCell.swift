//
//  PostCell.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit
import Kingfisher

class PostCell: UITableViewCell {
        
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupViews() {
        
        [postImageView, likeCountLabel, commentCountLabel, createdAtLabel, postLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 250),

            likeCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            likeCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likeCountLabel.trailingAnchor.constraint(equalTo: commentCountLabel.leadingAnchor, constant: -10),

            commentCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            commentCountLabel.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 10),
            
            createdAtLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            createdAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            postLabel.topAnchor.constraint(equalTo: likeCountLabel.bottomAnchor, constant: 8),
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            postLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
        
    public func configure(imageURL: URL?,
                          text: String, comments: Int,
                          likes: Int, date: String) {
        self.layer.cornerRadius = 10.0
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        postLabel.text = text
        likeCountLabel.attributedText = createImageString(text: likes, symbol: "heart")
        commentCountLabel.attributedText = createImageString(text: comments, symbol: "text.bubble")
        createdAtLabel.text = date
        
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(
            with: imageURL,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
    
    private func createImageString(text: Int, symbol: String) -> NSAttributedString {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: symbol)

        let imageString = NSMutableAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)")
        imageString.append(textString)

        return imageString
    }
}
