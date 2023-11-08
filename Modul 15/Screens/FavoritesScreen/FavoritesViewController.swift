//
//  FavoritesViewController.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

// MARK: - Imports

import SnapKit
import UIKit

// MARK: - FavoritesViewController

final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Private Properties

    private var movies: [MovieDisplayModel] = []

    @Injected private var favoritesService: FavoritesService!

    // MARK: - UI Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        movies = favoritesService.loadFavorites()
        setupViews()
        setupConstraints()
        setupTableView()
        setupNavigationBar()
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        detailsVC.set(movie: movies[indexPath.row])
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.description(), for: indexPath) as? MovieCell
        else {
            return UITableViewCell()
        }

        cell.set(model: movies[indexPath.row])
        return cell
    }
}

// MARK: - Private properties

fileprivate extension FavoritesViewController {

    func setupTableView() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupViews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        title = Constants.pageTitle
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: Constants.pageTitleFontSize, weight: .semibold),
            .foregroundColor: UIColor.systemPink
        ]
    }
}

// MARK: - Constants

fileprivate extension FavoritesViewController {
    enum Constants {
        static let pageTitle: String = "Favorite movies"
        static let pageTitleFontSize: CGFloat = 24
        static let rowHeight: CGFloat = 110
    }
}
