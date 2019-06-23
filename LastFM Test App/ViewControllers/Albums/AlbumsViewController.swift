//
//  AlbumsViewController.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import UIKit
import AlamofireImage

final class AlbumsViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    var artist: Artist? {
        didSet {
            if let artist = artist {
                title = artist.name
                navigationItem.rightBarButtonItems?.removeFirst()
            }
        }
    }

    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        if let artist = artist {
            loadServerData(for: artist)
        }
    }

    private func loadServerData(for artist: Artist) {
        NetworkManager.topAlbums(with: artist) { (list) in
            self.albums = list
            self.collectionView.reloadData()
        }
    }

    @IBAction func editAction(_ sender: Any) {
        setEditing(!isEditing, animated: true)
        let visibleItems = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleItems)
    }

}

extension AlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = albums[indexPath.item]
        if isEditing {
            if let cell = collectionView.cellForItem(at: indexPath) {
                item.isSelected = !item.isSelected
                cell.isSelected = !cell.isSelected
            }
        } else {
            performSegue(withIdentifier: Segue.DetailSegue, sender: item)
        }
    }
}

extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.CellId, for: indexPath) as! AlbumCollectionViewCell

        let item = albums[indexPath.item]
        cell.titleLabel.text = item.name
        cell.artistLabel.text = item.artist.name
        cell.setEditing(editing: isEditing)
        cell.isSelected = item.isSelected
        if let url = item.coverImageURL(with: .large) {
            cell.coverLoadingIndicatorView.startAnimating()
            cell.coverImageView.af_setImage(withURL: url) { [weak cell] _ in
                cell?.coverLoadingIndicatorView.stopAnimating()
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
}

