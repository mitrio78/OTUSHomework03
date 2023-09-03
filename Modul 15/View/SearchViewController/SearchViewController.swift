//
//  ViewController.swift
//
//  Created by Dmitriy Grishechko on 05.04.2023.
//

import SnapKit
import UIKit

// MARK: - SearchViewController

final class SearchViewController: UIViewController {

    // MARK: - Properties

    var kinopoiskService: SearchServiceProtocol!
    var omdbService: SearchServiceProtocol!

    // MARK: - Private Properties

    private var movies: [MovieDisplayModel] = []
    private var timer: Timer?
    private var currentSearchService: SearchServiceProtocol {
        switch searchType {
        case .kinopoisk:
            return kinopoiskService

        case .omdb:
            return omdbService
        }
    }
    private var searchType: SearchServiceType = .omdb

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
        button.addTarget(nil, action: #selector(switchService), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        kinopoiskService = KinopoiskSearchService()
        omdbService = OMDBSearchService()
        setupNavigationBar()
        setupViews()
        setupConstraints()
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
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.set(delegate: self)
        cell.set(model: movies[indexPath.row])
        return cell
    }
}

// MARK: - UISearchBarDelegat

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty, searchText.count > 2 else {
            return
        }

        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.startLoading()
            self.fetchData(searchText: searchText)
        }
    }
}

// MARK: - CustomCellDelegate

extension SearchViewController: CustomCellDelegate {
    func uploadImages(for id: String, image urlString: String, completion: ((UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let cacheImage = self?.movies.first(where: { $0.id == id })?.image else {
                self?.currentSearchService.getImage(urlString: urlString) { image in
                    if let movieIndex = self?.movies.firstIndex(where: { $0.id == id }) {
                        self?.movies[movieIndex].image = image
                    }
                    DispatchQueue.main.async {
                        completion?(image)
                    }
                }
                return
            }
            DispatchQueue.main.async {
                completion?(cacheImage)
            }
        }
    }
}

// MARK: - Private

fileprivate extension SearchViewController {

    // MARK: - Button Actions

    @objc
    func switchService() {
        movies = []
        tableView.reloadData()

        switch searchType {
        case .omdb:
            searchType = .kinopoisk
            setKinopoiskInterface()

        case .kinopoisk:
            searchType = .omdb
            setOMDBInterface()
        }
        repeatSearch()
    }

    // MARK: - Private Methods

    func fetchData(searchText: String) {
        currentSearchService.handleRequest(searchText: searchText) { [weak self] searchResult, errorMessage in
            if let errorMessage = errorMessage {
                self?.stopLoading()
                self?.resetData()
                DispatchQueue.main.async {
                    self?.showError("Network error:\n\(errorMessage)")
                }
                return
            }

            self?.movies = searchResult

            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.stopLoading()
            }
        }
    }

    func startLoading() {
        errorLabel.isHidden = true
        errorLabel.text = ""
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func resetData() {
        movies = []
        tableView.reloadData()
    }

    func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func showError(_ message: String) {
        movies = []
        tableView.reloadData()
        errorLabel.isHidden = false
        errorLabel.text = message
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
            action: nil
        )
    }

    func repeatSearch() {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }

        fetchData(searchText: text)
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
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
