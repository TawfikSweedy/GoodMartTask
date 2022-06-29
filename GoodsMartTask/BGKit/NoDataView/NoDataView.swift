//
//  NoDataView.swift
//
//  Created by apple on 9/22/20.
//

import UIKit
import Lottie

class NoDataView: UIView {

    let nibName = "NoDataView"

    @IBOutlet weak var smallTitleLbl: UILabel!
    @IBOutlet weak var bigTitleLbl: UILabel!
    @IBOutlet weak var animationView: AnimationView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    var bigTitle: String? {
        didSet {
            bigTitleLbl.text = bigTitle
        }
    }
    
    var smallTitle: String? {
        didSet {
            smallTitleLbl.text = smallTitle
        }
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
