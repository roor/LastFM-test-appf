//
//  SearchTableViewController.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/22/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import UIKit

final class SearchTableViewController: UITableViewController {

    fileprivate var artists = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)

        let item = artists[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.listeners

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = artists[indexPath.row]

        performSegue(withIdentifier: Segue.AlbumsSegue, sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumsViewController, let item = sender as? Artist {
            destination.artist = item
        }
    }

    private func performSearch(_ query: String) {
        NetworkManager.search(for: query) { list in
            self.artists = list
            self.tableView.reloadData()
        }
    }

}

extension SearchTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            performSearch(query)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            artists.removeAll()
            tableView.reloadData()
        }
    }
}

