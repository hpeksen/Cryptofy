//
//  ViewController.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 9.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var searchCoinValues: [CryptoDataModel] = []
    var searchActive = true
    var colorArray = [UIColor]()
    private var cryptoListViewModel: CryptoListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        }
    
    private func setupUI(){
          // Collection View
          collectionView.delegate = self
          collectionView.dataSource = self
        self.colorArray = [
            UIColor(red:255,green: 0,blue: 0,alpha:1),
            UIColor(red:0,green: 255,blue: 0,alpha:1),
            UIColor(red:0,green: 0,blue: 255,alpha:1),
        ]
          
          // Register custom cell
          collectionView.register(.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
      }

    @IBAction func btnUpdateData(_ sender: Any) {
    
        getData()
        
    }
    private func getData(){
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc")!
        WebService().downloadCurrencies(url: url) { cryptos in
            if let cryptos = cryptos {
                self.cryptoListViewModel = CryptoListViewModel(cryptoCurrencyList: cryptos)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ViewController:UICollectionViewDelegate{
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.valueLabel.text = "\(cryptoListViewModel.cryptoAtIndex(indexPath.row).price)"
        cell.unitLabel.text = cryptoListViewModel.cryptoAtIndex(indexPath.row).name
        cell.collectionViewCell.backgroundColor = self.colorArray[indexPath.row % 3]
        // Create URL
        let url = URL(string: self.cryptoListViewModel.cryptoAtIndex(indexPath.row).image)!
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchCoinValues.count != 0{
            return searchCoinValues.count
        }else{
            return cryptoListViewModel?.getAllData().count ?? 0
        }
            
    }
}

extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCoinValues = cryptoListViewModel.getAllData().filter({$0.name.lowercased().contains(searchText.lowercased())})
        self.collectionView.reloadData()
    }
}

