//
//  AlbumCollectionViewCell.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import UIKit

final class AlbumCollectionViewCell: UICollectionViewCell {
    static let CellId = "AlbumCell"
    
    @IBOutlet weak var labelsContainerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var coverLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var selectionButton: UIButton!

    var isEditing: Bool = false {
        didSet {
            selectionButton.isHidden = !isEditing
            coverImageView.alpha = isEditing ? 0.5 : 1
        }
    }

    var isDownloaded: Bool = false {
        didSet {
            if isEditing {
                selectionButton.isHidden = isDownloaded
                coverImageView.alpha = isDownloaded ? 1 : 0.5
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        coverImageView.layer.cornerRadius = 2
        labelsContainerView.layer.cornerRadius = 14
    }
}
