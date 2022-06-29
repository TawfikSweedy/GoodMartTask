//
//  LatestNewsCollectionViewCell.swift
//
//

import UIKit
import SDWebImage

class LatestNewsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var latestNewsImg: UIImageView!
  @IBOutlet weak var latestNewsTitleLabel: UILabel!

  func setupCell(data: Articles) {
      latestNewsTitleLabel.text = data.title
      latestNewsImg.sd_setImage(with: URL(string: data.urlToImage ?? ""), completed: nil)
      latestNewsImg.contentMode = .scaleAspectFill
      latestNewsImg.layer.cornerRadius = 8
  }
}
