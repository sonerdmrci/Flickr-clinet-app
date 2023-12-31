//
//  RecenPhotosTableViewController.swift
//  FlickrClinetAppSwift
//
//  Created by Soner Demirci on 31.08.2023.
//

import UIKit

class RecenPhotosTableViewController: UITableViewController, UISearchResultsUpdating{
    private var response: PhotosResponse?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    private var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecentPhotos()
    }
    private func setupSearchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    private func fetchRecentPhotos(){
        //Istegi yapiyoruz
        //"https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=7dd89640e14551c5df5f7bbae1f68223&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z"
        //"https://www.flickr.com/services/rest/?method=flickr.photos.get&api_key=b9b9c8bac280bb9b264403e073943e06&text=flower&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z"
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=b9b9c8bac280bb9b264403e073943e06&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z")else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data){
                self.response = response
            }
        }.resume()
    }
    
    private func searchPhotos(with text: String){
        //Istegi yapiyoruz
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=b9b9c8bac280bb9b264403e073943e06&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z")else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data){
                self.response = response
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos.photo?.count ?? .zero
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = response?.photos.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.ownerImageView.backgroundColor = .darkGray
        cell.ownerNameLabel.text = photo?.ownername
        
        //Profil fotografi cekme
        NetworkManager.shared.fetcImage(with: photo?.buddyIconURL) { data in
            cell.ownerImageView.image = UIImage(data: data)
        }
            
        //gonderi fotografi cekme
        NetworkManager.shared.fetcImage(with: photo?.urlN) {data in
            cell.photoImageView.image = UIImage(data: data)
        }
            
        cell.titleLabel.text = photo?.title
        return cell
            
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = response?.photos.photo?[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PhotoDetailViewController{
            //TODO: secilen fotografi detay ekranina gonder
            viewController.photo = selectedPhoto
        }
    }
        
    //MARK: -UISearchResultUpdateing
        
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2{
            searchPhotos(with: text)
        }
    }
        
        
}

