//
//  ViewController.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 9.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var coinValues: [JsonObject] = []
    private var searchCoinValues: [JsonObject] = []
    var searchActive = true
    var colorArray = [UIColor]()
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
        guard let url = URL.init(string: "https://api.nomics.com/v1/currencies/ticker?key=6d0388dae8b60809c5f2562ab235012d6a2e27a3&ids=BTC,ETH,USDT,USDC,BNB,ADA,XRP,BUSD,SOL,DOGE,DOT&interval=1d")else{
            return
        }
               let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   if error != nil {
                       let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                       let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                       alert.addAction(okButton)
                       self.present(alert, animated: true, completion: nil)
                   }else{
                       guard let data = data, error == nil else {
                           return
                       }
                       
                           do{
                               // Decode response
                               let result = try JSONDecoder().decode([JsonObject].self, from: data)
                               self.coinValues = result
                               print(self.searchCoinValues)
                               DispatchQueue.main.async {
                                   self.collectionView.reloadData()
                               }
                           }catch{
                               print(error)
                           }
                          
                   }
               }
               task.resume()
        
    }
}

extension ViewController:UICollectionViewDelegate{
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.valueLabel.text = coinValues[indexPath.row].price
        cell.unitLabel.text = coinValues[indexPath.row].name
        cell.collectionViewCell.backgroundColor = self.colorArray[indexPath.row % 3]
        // Create URL
        let url = URL(string: self.coinValues[indexPath.row].logo_url!)!
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
            return coinValues.count;
        }
            
    }
}

extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCoinValues = coinValues.filter({$0.name!.lowercased().contains(searchText.lowercased())})
        self.collectionView.reloadData()
    }
}

