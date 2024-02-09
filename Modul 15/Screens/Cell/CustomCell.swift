//
//  CustomCell.swift
//
//  Created by Dmitriy Grishechko on 05.04.2023.
//

import SnapKit
import UIKit

// MARK: - MovieCellDelegate

protocol MovieCellDelegate: AnyObject {
    func uploadImages(for id: String, image urlString: String) async throws -> Data?
}

// MARK: - Custom Cell

final class MovieCell: UITableViewCell {

    weak var delegate: MovieCellDelegate?

    private var imageUrlString: String? {
        didSet {
            self.loadImage(url: imageUrlString)
        }
    }
    private var movieId: String!

    // MARK: - UI

    private lazy var title: UILabel = {
        let title = UILabel()
        title.font = Constants.titleFont
        title.textColor = .systemPurple
        title.font = .systemFont(ofSize: 16, weight: .heavy)
        return title
    }()
    
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.font = Constants.textFont
        view.numberOfLines = .zero
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.tintColor = .systemPink
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()

    // MARK: - Public Methods

    public func set(model: MovieDisplayModel) {
        movieId = model.id
        title.text = model.title
        textView.text = model.description

        if let imageData = model.image {
            self.image.image = UIImage(data: imageData)
        }

        self.imageUrlString = model.imageURL
    }

    public func set(delegate: MovieCellDelegate) {
        self.delegate = delegate
    }

    // MARK: - Inheritance

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

fileprivate extension MovieCell {
    func setupViews() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(textView)
        image.addSubview(loader)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(Constants.standardOffset)
            $0.top.equalTo(contentView.snp.top).offset(Constants.standardOffset)
            $0.width.equalTo(Constants.imageWidth)
            $0.height.equalTo(Constants.imageHeight)
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(Constants.standardOffset)
            $0.top.equalToSuperview().offset(Constants.standardOffset)
        }
        
        textView.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(Constants.standardOffset)
            $0.top.equalTo(title.snp.bottom).offset(Constants.halfOffset)
            $0.trailing.equalToSuperview().inset(Constants.textTrailingInset)
            $0.bottom.equalToSuperview().inset(Constants.standardInset)
        }

        loader.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func initLoader() {
        loader.isHidden = false
        loader.startAnimating()
    }

    func stopLoader() {
        loader.stopAnimating()
        loader.isHidden = true
    }

    func loadImage(url: String?) {
        initLoader()

        guard let url = url else {
            stopLoader()
            image.image = Constants.defaultImage
            return
        }

        Task { @MainActor in
            do {
                let imageData = try await delegate?.uploadImages(for: movieId, image: url)

                guard let imageData, let uiImage = UIImage(data: imageData) else {
                    image.image = Constants.defaultImage
                    return
                }

                image.image = uiImage
                stopLoader()
            } catch {
                debugPrint("Image Loading error: \(error.localizedDescription)")
                stopLoader()
            }
        }
    }
}

// MARK: - Constants

fileprivate extension MovieCell {
    enum Constants {
        static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let textFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
        static let timeFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
        static let standardOffset: CGFloat = 16
        static let standardInset: CGFloat = 16
        static let timeLabelTopOffset: CGFloat = 18
        static let halfOffset: CGFloat = 8
        static let halfInset: CGFloat = 8
        static let textTrailingInset: CGFloat = 24
        static let imageHeight: CGFloat = 75
        static let imageWidth: CGFloat = 50
        static let defaultImage: UIImage? = .init(systemName: "popcorn.fill")
    }
}
