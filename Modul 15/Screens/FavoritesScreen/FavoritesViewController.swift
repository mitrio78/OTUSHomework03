//
//  FavoritesViewController.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import SnapKit
import UIKit

final class FavoritesViewController: UIViewController {

    private var movies: [MovieDisplayModel] = []

    private var favoritesService: FavoritesServiceProtocol!

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesService = FavoritesService.shared
        movies = favoritesService.loadFavorites()
        setupViews()
        setupConstraints()
        setupTableView()
        setupNavigationBar()
    }
}

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

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        cell.set(delegate: self)
        cell.set(model: movies[indexPath.row])
        return cell
    }
}

extension FavoritesViewController: MovieCellDelegate {
    func uploadImages(for id: String, image urlString: String, completion: ((Data?) -> Void)?) {
        // TODO: - upload images
    }
}

fileprivate extension FavoritesViewController {

    func setupTableView() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: "cell")
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

fileprivate extension FavoritesViewController {
    enum Constants {
        static let pageTitle: String = "Favorite movies"
        static let pageTitleFontSize: CGFloat = 24
        static let rowHeight: CGFloat = 110
    }
}
