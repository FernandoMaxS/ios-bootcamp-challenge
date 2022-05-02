//
//  CardView.swift
//  iOS Bootcamp Challenge
//
//  Created by Marlon David Ruiz Arroyave on 28/09/21.
//

import UIKit

class CardView: UIView {

    private let margin: CGFloat = 30
    var card: Card?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy private var subTitleLabel: [UILabel] = {
        var labels:[UILabel] = []
        for i in 0..<4{
            let label = UILabel()
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            labels.append(label)
        }
        
        return labels
    }()
    lazy private var descriptionLabel: [UILabel] = {
        var labels:[UILabel] = []
        for i in 0..<4{
            let label = UILabel()
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            labels.append(label)
        }
        
        return labels
    }()
    required init(card: Card) {
        self.card = card
        super.init(frame: .zero)
        setup()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupUI()
    }

    private func setup() {
        guard let card = card else { return }
        
        var index = 0
        card.items.forEach { item in
            subTitleLabel[index].text = item.title
            descriptionLabel[index].text = item.description
            index += 1
        }

        titleLabel.text = card.title
        backgroundColor = .white
        layer.cornerRadius = 20

    }

    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin * 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true

        // TODO: Display pokemon info (eg. types, abilities)
    
        
        for i in 0..<4{
            addSubview(subTitleLabel[i])
            subTitleLabel[i].topAnchor.constraint(equalTo: self.topAnchor, constant: margin * CGFloat((i+3))).isActive = true
            subTitleLabel[i].leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
            subTitleLabel[i].widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.90).isActive = true
            
            addSubview(descriptionLabel[i])
            descriptionLabel[i].topAnchor.constraint(equalTo: self.topAnchor, constant: margin * CGFloat((i+3))).isActive = true
            descriptionLabel[i].leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin*7).isActive = true
            descriptionLabel[i].widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.90).isActive = true
        }
        
    }

}
