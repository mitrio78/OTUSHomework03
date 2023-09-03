//
//  DetailsViewController.swift
//
//  Created by Dmitriy Grishechko on 13.05.2023.
//

import SnapKit
import UIKit

// MARK: - DetailsViewController

final class DetailsViewController: UIViewController {

    // MARK: - Private properties

    private var movieDetails: MovieDisplayModel!

    // MARK: - UI properties

    private lazy var coverImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemPink
        view.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.layer.shadowOpacity = 5
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = .zero
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 20, weight: .black)
        view.textAlignment = .center
        return view
    }()

    private lazy var descriptionText: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(top: 8, left: 32, bottom: 16, right: 32)
        view.isEditable = false
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        setupNavBar()
    }

    // MARK: - Puclic methods

    func set(movie details: MovieDisplayModel) {
        movieDetails = details
        coverImage.image = details.image
        titleLabel.text = details.title
        descriptionText.text = details.fullDescription ?? details.description
    }
}

// MARK: - Private methods

fileprivate extension DetailsViewController {
    func setupViews() {
        view.addSubview(coverImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionText)
    }

    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .systemPink
    }

    func setupConstraints() {
        coverImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.imageTopOffset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.imageHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(coverImage.snp.bottom).offset(Constants.titleTopOffset)
        }

        descriptionText.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.descriptionTopOffset)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

fileprivate extension DetailsViewController {
    enum Constants {
        static let imageHeight: CGFloat = 340
        static let imageTopOffset: CGFloat = 24
        static let titleTopOffset: CGFloat = 24
        static let descriptionTopOffset: CGFloat = 16
    }
}
