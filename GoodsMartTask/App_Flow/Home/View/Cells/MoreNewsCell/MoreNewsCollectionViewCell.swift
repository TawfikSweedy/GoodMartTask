//
//  MoreNewsCollectionViewCell.swift
//
//

import UIKit
import CoreData

class MoreNewsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var moreNewsDescribtionLabel: UILabel!
  @IBOutlet weak var moreNewsImg: UIImageView!
  @IBOutlet weak var moreNewsTitleLabel: UILabel!
    

    func setupCell(data: Articles) {
        moreNewsTitleLabel.text = data.title
        moreNewsImg.sd_setImage(with: URL(string: data.urlToImage ?? ""), completed: nil)
        moreNewsImg.contentMode = .scaleAspectFill
        moreNewsDescribtionLabel.text = data.description
    }
    
    func setupHistoryCell(data: NSManagedObject ) {
        moreNewsTitleLabel.text = data.value(forKey: "title") as? String
        moreNewsImg.sd_setImage(with: URL(string: data.value(forKey: "image") as? String ?? "" ), completed: nil)
        moreNewsImg.contentMode = .scaleAspectFill
        moreNewsDescribtionLabel.text = data.value(forKey: "descriptions") as? String
    }

}
