//
//  PostCell.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit
import Kingfisher

class PostCell: UITableViewCell {
        
    private let indent = Constraints.standardIndent
    private let smallIndent = Constraints.midIndent
    private let imageHeight = Constraints.carImageSize
    private let bottomIndent = Constraints.bottomIndent
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSizes.postText)
        label.numberOfLines = 2
        return label
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSizes.commentsAndLikes)
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSizes.commentsAndLikes)
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSizes.date)
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
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: smallIndent),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            likeCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: smallIndent),
            likeCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: smallIndent),
            likeCountLabel.trailingAnchor.constraint(equalTo: commentCountLabel.leadingAnchor, constant: -indent),

            commentCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: smallIndent),
            commentCountLabel.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: indent),
            
            createdAtLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: smallIndent),
            createdAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -smallIndent),
            
            postLabel.topAnchor.constraint(equalTo: likeCountLabel.bottomAnchor, constant: smallIndent),
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: smallIndent),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -smallIndent),
            postLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomIndent)
        ])
    }
        
    public func configure(imageURL: URL?,
                          text: String, comments: Int,
                          likes: Int, date: String) {
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
