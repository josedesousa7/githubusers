//
//  UserDetailViewController.swift
//  githubusers
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - UIElements
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLoginNameLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var numberOfRepositoriesLabel: UILabel!
    @IBOutlet var userInfoLabels: [UILabel]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userInfoStackView: UIStackView!

    // MARK: - Properties
    
    private var dataSource: DataProviderProtocol?
    private var viewModel: UserDetailViewModel?
    var user: GitHubUser?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userPictureImageView.layer.cornerRadius = self.userPictureImageView.frame.size.height / 2
        self.dataSource = setupDataSource()
        activityIndicator.startAnimating()
        self.title = NSLocalizedString("user_detail_title", comment: "")
        setupViewModel()
        fetchUserDetail()
        userInfoStackView.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupUser(user: GitHubUser?) {
        self.user = user
        userLoginNameLabel.text = user?.login
        userNameLabel.text = user?.name
        userWebsiteLabel.text = user?.htmlUrl
        userCompanyLabel.text = user?.company
        numberOfRepositoriesLabel.text = String(user?.publicRepos ?? 0)
        for label in userInfoLabels {
            label.isHidden = label.text == nil
        }
    }
    
    private func setupViewModel() {
        guard let dataSource = dataSource else {
            return
        }
        self.viewModel = UserDetailViewModel(dataSource: dataSource)
    }
    
    private func setupDataSource() -> DataProvider {
        return DataProvider(dataSource: HttpRequestManager())
    }
    
    private func fetchUserDetail() {
        if let user = user {
            self.viewModel?.showUserWithName(name: user.login ?? "") {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.activityIndicator.stopAnimating()
                    self.userInfoStackView.isHidden = false
                    self.setupUser(user: user)
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    print(error.localizedDescription)
                }
            }
            self.viewModel?.showUserImage(user: user) {[weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.userPictureImageView.image = result
                }
            }
        }
    }
}
