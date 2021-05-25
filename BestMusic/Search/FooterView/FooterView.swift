//
//  FooterView.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 25.05.2021.
//

import UIKit

class FooterView: UIView {

    // MARK: Properties

    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return label
    }()

    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupElements()
    }

}

// MARK: Public methods

extension FooterView {

    func showLoader() {
        loader.startAnimating()
        label.text = "LOADING"
    }

    func hideLoader() {
        loader.stopAnimating()
        label.text = ""
    }

}


// MARK: Private methods

private extension FooterView {

    func setupElements() {
        addSubview(label)
        addSubview(loader)

        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true

        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }

}
