//
//  AlbumsViewController.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

/**
 Showing stored albums, also used for showing albums after search.
 */
final class AlbumsViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    let realm = try! Realm()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalData()
    }

    private func fetchLocalData() {
        if artist == nil {
            let realm = try! Realm()
            let realmAlbums = realm.objects(Album.self).filter("isDownloaded = 1")
            albums = Array(realmAlbums)
        }
        collectionView.reloadData()
    }

    private func loadServerData(for artist: Artist) {
        let realmAlbums = realm.objects(Album.self).filter("artist.mbid = %@", artist.mbid as Any)

        NetworkManager.topAlbums(with: artist) { (list) in
            self.albums = list
            realmAlbums.forEach({ (album) in
                if let index = self.albums.firstIndex(where: { $0.mbid == album.mbid }) {
                    self.albums[index] = album
                }
            })

            self.collectionView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumDetailsViewController, let item = sender as? Album {
            destination.album = item
        }
    }

    @IBAction func editAction(_ sender: Any) {
        setEditing(!isEditing, animated: true)
        if !isEditing {
            editButton.style = .plain
            editButton.title = NSLocalizedString("Edit", comment: "Edit button")
            save()
        } else {
            editButton.style = .done
            editButton.title = NSLocalizedString("Done", comment: "Done button")
        }
        fetchLocalData()
    }

    private func save() {
        try! realm.write {
            albums.forEach { (album) in
                if album.isDownloaded {
                    realm.add(album, update: .modified)
                }
            }
        }
    }
}

extension AlbumsViewController: UICollectionViewDelegate {

    func toggleSelection(at indexPath: IndexPath) {
        let item = albums[indexPath.item]

        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            try! realm.write {
                item.isDownloaded = !item.isDownloaded
            }
            cell.isDownloaded = item.isDownloaded
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = albums[indexPath.item]
        if isEditing {
            toggleSelection(at: indexPath)
        } else {
            performSegue(withIdentifier: Segue.DetailSegue, sender: item)
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            toggleSelection(at: indexPath)
        }
    }
}

extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.CellId, for: indexPath) as! AlbumCollectionViewCell

        let item = albums[indexPath.item]
        cell.titleLabel.text = item.name
        cell.artistLabel.text = item.artist.name
        cell.isEditing = isEditing
        if isEditing {
            cell.isDownloaded = item.isDownloaded
        } else {
            cell.isDownloaded = false
        }
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

