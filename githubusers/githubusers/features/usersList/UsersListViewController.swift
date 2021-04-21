//
//  UsersListViewController.swift
//  githubusers
//
//  Created by José Marques on 18/04/2021.
//

import UIKit

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: UsersListViewModel?
    private var dataSource: DataProviderProtocol?
    private var usersList: [GitHubUser] = []
    private var user: GitHubUser?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.dataSource = setupDataSource()
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
        setupViewModel()
        self.title = NSLocalizedString("user_list_title", comment: "GitHub Users")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUserList()
        searchBar.text = ""
    }
    // MARK: - Private methods


    private func setupViewModel() {
        guard let dataSource = dataSource else {
            return
        }
        self.viewModel = UsersListViewModel(dataSource: dataSource)
    }

    private func setupDataSource() -> DataProvider {
        return DataProvider(dataSource: HttpRequestManager())
    }

    private func requestUserList() {
        viewModel?.showUsersList {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userList):
                self.usersList = userList
                self.tableView.reloadData()
            case .failure(let error):
                self.presentAlertController(withTitle: "Opps!", andMessage: NSLocalizedString("no_internet_connection", comment: ""))
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableView

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier) as? UserTableViewCell {
            let model = usersList[indexPath.row]
            let viewModel = UserTableViewCellViewModel(model: model, dataSource: setupDataSource())
            cell.configureCellWith(viewModel: viewModel)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userToPresent = usersList[indexPath.row]
        presentDetailsFor(user: userToPresent)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UISearchBar

extension UsersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text else {return}
        self.viewModel?.showUserWithName(name: text) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userList):
                self.usersList = userList
                self.tableView.reloadData()
            case .failure(let error):
                self.presentAlertController(withTitle: "Opps!", andMessage: NSLocalizedString("user_not_found", comment: ""))
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Navigation

extension UsersListViewController {
    func presentDetailsFor(user: GitHubUser) {
        self.user = user
        self.performSegue(withIdentifier: Constants.detailSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailSegue {
            guard let destinationVc = segue.destination as? UserDetailViewController else {return}
            destinationVc.user = self.user
        }
    }
}
