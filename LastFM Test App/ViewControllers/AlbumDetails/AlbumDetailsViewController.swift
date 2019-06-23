//
//  AlbumDetailsViewController.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import UIKit
import RealmSwift

final class AlbumDetailsViewController: UIViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadContainerView: UIView!
    @IBOutlet weak var downloadSwitch: UISwitch!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var album: Album!

    fileprivate var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadContainerView.layer.cornerRadius = 10

        title = album.name
        navigationItem.prompt = album.artist.name

        downloadSwitch.isOn = album.isDownloaded

        activityIndicatorView.startAnimating()
        if let url = album.coverImageURL(with: .extraLarge) {
            coverImageView.af_setImage(withURL: url) { [weak self] _ in
                self?.activityIndicatorView.stopAnimating()
            }
        }

        if !album.tracks.isEmpty {
            tracks = Array(album.tracks)
            tableView.reloadData()
        } else {
            loadAlbumInfo()
        }
    }

    fileprivate func loadAlbumInfo() {
        NetworkManager.albumInfo(with: album) { (tracks) in
            if let tracks = tracks {
                self.tracks = tracks
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func downloadAction(_ sender: UISwitch) {
        let realm = try! Realm()
        try! realm.write {
            album.isDownloaded = sender.isOn
        }
    }

}

extension AlbumDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)

        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = track.duration.time()

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
}
