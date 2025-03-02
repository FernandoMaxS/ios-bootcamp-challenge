//
//  ListViewController.swift
//  iOS Bootcamp Challenge
//
//  Created by Jorge Benavides on 26/09/21.
//

import UIKit
import SVProgressHUD

class ListViewController: UICollectionViewController {

    private var pokemons: [Pokemon] = []
    private var resultPokemons: [Pokemon] = []
    private var currentPokemon: Pokemon?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // TODO: Use UserDefaults to pre-load the latest search at start

    private var latestSearch: String?

    lazy private var searchController: SearchBar = {
        let searchController = SearchBar("Search a pokemon", delegate: nil)
        searchController.text = latestSearch
        searchController.showsCancelButton = !searchController.isSearchBarEmpty
        return searchController
    }()

    private var isFirstLauch: Bool = true

    // TODO: Add a loading indicator when the app first launches and has no pokemons

    private var shouldShowLoader: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setupUI()
    }

    // MARK: Setup

    private func setup() {
        title = "Pokédex"

        // Customize navigation bar.
        guard let navbar = self.navigationController?.navigationBar else { return }

        navbar.tintColor = .black
        navbar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navbar.prefersLargeTitles = true

        // Set up the searchController parameters.
        navigationItem.searchController = searchController
        definesPresentationContext = true

        refresh()
    }

    private func setupUI() {

        // Set up the collection view.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white

        // Set up the refresh control as part of the collection view when it's pulled to refresh.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.sendSubviewToBack(refreshControl)
    }

    // MARK: - UISearchViewController

    private func filterContentForSearchText(_ searchText: String) {
        // filter with a simple contains searched text
        resultPokemons = pokemons
            .filter {
                searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
            }
            .sorted {
                $0.id < $1.id
            }

        collectionView.reloadData()
    }

    // TODO: Implement the SearchBar

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultPokemons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.identifier, for: indexPath) as? PokeCell
        else { preconditionFailure("Failed to load collection view cell") }
        cell.pokemon = resultPokemons[indexPath.item]
        return cell
    }
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Click: \(resultPokemons[indexPath.item])")
        currentPokemon = resultPokemons[indexPath.item]
        performSegue(withIdentifier: "goDetailViewControllerSegue", sender: self)
    }*/

    // MARK: - Navigation

    // TODO: Handle navigation to detail view controller
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? DetailViewController {
            destino.pokemon = self.currentPokemon
        }
    }*/
    //Revisar error de perform segue twice sol: https://ajpagente.github.io/mobile/002/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "goDetailViewControllerSegue" {
        if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell){
          let controller = segue.destination as! DetailViewController
            controller.pokemon = resultPokemons[indexPath.item]
        }
      }
    }
    // MARK: - UI Hooks

    @objc func refresh(){
        shouldShowLoader = true
        let group = DispatchGroup()//Se agrego para realizar la espera
        
        var pokemons: [Pokemon] = []

        // TODO: Wait for all requests to finish before updating the collection view
        activityIndicator.startAnimating()
        PokeAPI.shared.get(url: "pokemon?limit=30", onCompletion: { (list: PokemonList?, _) in
            guard let list = list else { return }
            list.results.forEach { result in
                group.enter()//Se inicia
                PokeAPI.shared.get(url: "/pokemon/\(result.id)/", onCompletion: { (pokemon: Pokemon?, _) in
                    guard let pokemon = pokemon else { return }
                    //print(pokemon)
                   
                    pokemons.append(pokemon)
                    self.pokemons = pokemons
                    group.leave()//termina
                })
            }
            group.notify(queue: .main) {//Se notifica al hilo principal para actualizar
                // all data available, continue
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            self.didRefresh()
        }
        }
        )

    }
   

    private func didRefresh() {
        shouldShowLoader = false

        guard
            let collectionView = collectionView,
            let refreshControl = collectionView.refreshControl
        else { return }

        refreshControl.endRefreshing()

        filterContentForSearchText("")
    }

}
