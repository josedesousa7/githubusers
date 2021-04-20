//
//  UserTableViewCell.swift
//  githubusers
//
//  Created by José Marques on 19/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: Properties

    static let reuseIdentifier = "userTableViewCell"
    private var viewModel: UserTableViewCellViewModel?
    @IBOutlet weak var userLoginNameLabel: UILabel!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    //MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startAnimating()
        self.userLoginNameLabel.font = UIFont(name: "System", size: 20.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.userProfilePhoto.layer.cornerRadius =  self.userProfilePhoto.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Private Methods

    private func setupUI() {
        guard let viewModel = self.viewModel else { return }
        userLoginNameLabel.text = viewModel.model.login 
        DispatchQueue.main.async {
            viewModel.showUserImage{ result in
                self.loadingIndicator.stopAnimating()
                self.userProfilePhoto.image = result
            }
        }
    }

    //MARK: - Public Methods

    func configureCellWith(viewModel: UserTableViewCellViewModel) {
        self.viewModel = viewModel
        setupUI()
    }
}
