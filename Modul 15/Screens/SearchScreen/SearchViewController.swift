//
//  ViewController.swift
//
//  Created by Dmitriy Grishechko on 05.04.2023.
//

import Combine
import SnapKit
import UIKit

// MARK: - SearchViewController

final class SearchViewController: UIViewController {

    // MARK: - Dependencies

    @Injected private var viewModel: SearchViewModel!

    // MARK: - Private Properties

    private var cancellableMovies: AnyCancellable?
    private var cancellableLoader: AnyCancellable?
    private var cancellableSearchMode: AnyCancellable?

    private var movies: [MovieDisplayModel] = []

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Constants.errorLabelFont
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityView.isHidden = true
        activityView.style = .large
        activityView.color = .purple
        return activityView
    }()

    private lazy var serviceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Switch to Kinopoisk", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.titleLabel?.textColor = .white
        button.addTarget(nil, action: #selector(toggleService), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setObservers()
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] (action, view, completionHandler) in
            self?.viewModel.addToFavorites(indexPath.row)
            completionHandler(true)
        }

        action.backgroundColor = UIColor.systemMint
        action.image = UIImage(systemName: "star.fill")

        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        cell.set(delegate: viewModel)
        cell.set(model: movies[indexPath.row])
        return cell
    }
}

// MARK: - UISearchBarDelegat

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovie(searchText)
    }
}

// MARK: - Private

fileprivate extension SearchViewController {

    func setObservers() {
        cancellableSearchMode = viewModel.$searchType.sink { [weak self] searchType in
            self?.updateSearchType(searchType)
        }

        cancellableLoader = viewModel.$isLoading.sink { [weak self] isLoading in
            self?.setLoader(isLoading)
        }

        cancellableMovies = viewModel.$movies.sink { [weak self] movies in
            self?.movies = movies
            self?.tableView.reloadData()
        }
    }

    func updateSearchType(_ searchType: SearchServiceType) {
        switch searchType {
        case .kinopoisk:
            setKinopoiskInterface()

        case .omdb:
            setOMDBInterface()
        }
    }

    // MARK: - Button Actions

    @objc
    func toggleService() {
        viewModel.toggleSearchService()
        tableView.reloadData()
        repeatSearch()
    }

    @objc
    func openFavorites() {
        let favVC = FavoritesViewController()
        navigationController?.pushViewController(favVC, animated: true)
    }

    // MARK: - Private Methods

    func setLoader(_ isLoading: Bool) {
        isLoading
        ? startLoading()
        : stopLoading()
    }
    
    func startLoading() {
        errorLabel.isHidden = true
        errorLabel.text = ""
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func repeatSearch() {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }

        viewModel.searchMovie(text)
    }

    func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func setKinopoiskInterface() {
        serviceButton.setTitle("Switch to OMDB", for: .normal)
        title = "Kinopoisk Search"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: Constants.pageTitleFontSize, weight: .semibold),
            .foregroundColor: UIColor.systemPurple
        ]
        serviceButton.backgroundColor = .systemPurple
    }

    func setOMDBInterface() {
        serviceButton.setTitle("Switch to Kinopoisk", for: .normal)
        title = "OMDB Search"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: Constants.pageTitleFontSize, weight: .semibold),
            .foregroundColor: UIColor.systemPink
        ]
        serviceButton.backgroundColor = .systemPink
    }

    func setupNavigationBar() {
        title = Constants.pageTitle
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: Constants.pageTitleFontSize, weight: .semibold),
            .foregroundColor: UIColor.systemPink
        ]

        let rightBarButtomImage = UIImage(systemName: "star.square.on.square.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightBarButtomImage?.withTintColor(
                .orange,
                renderingMode: .alwaysOriginal
            ),
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )
    }

    // MARK: - UI SetUp

    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        view.addSubview(serviceButton)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
        }

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        serviceButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(tableView.snp.bottom).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.errorLabelInsets)
            $0.trailing.equalToSuperview().inset(Constants.errorLabelInsets)
        }
    }
}

// MARK: - Constants

fileprivate extension SearchViewController {
    enum Constants {
        static let pageTitle: String = "OMDB Search"
        static let pageTitleFontSize: CGFloat = 24
        static let rowHeight: CGFloat = 110
        static let errorLabelFont: UIFont = .systemFont(ofSize: 24, weight: .semibold)
        static let errorLabelInsets: CGFloat = 16
        static let numberOfDisplayedResults: Int = 10
    }
}
