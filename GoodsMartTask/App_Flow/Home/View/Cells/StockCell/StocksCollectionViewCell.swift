//
//  StocksCollectionViewCell.swift
//
//

import UIKit

class StocksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupCell(data: Stocks) {
        titleLabel.text = data.stock
        let price = Double(data.price.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
        
        if price < 0  {
//            print(doublePrice ?? 0.0)
            let price = String(format: "%.2f", price)
            priceLabel.text = "\(price) USD"
            priceLabel.textColor = .red
        }else{
            let price = String(format: "%.2f", price)
            priceLabel.text = "\(price) USD"
            priceLabel.textColor = .green
        }
    }
}
