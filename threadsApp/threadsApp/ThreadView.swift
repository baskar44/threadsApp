//
//  ThreadView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class ThreadView: UIView {

    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var threadTitleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure(createdDate: String, threadTitle: String, creatorUsername: String){
        createdDateLabel.text = createdDate
        threadTitleLabel.text = threadTitle
        creatorLabel.text = creatorUsername
      
        contentView.layer.cornerRadius = contentView.frame.width/12
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 0.05
    }
    
    private func commonInit(){
        //later
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        Bundle.main.loadNibNamed("ThreadView", owner: self, options: nil)
        addSubview(contentView)
        let frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: keyWindow.frame.width - 80, height: self.bounds.height)
        contentView.frame = frame
        contentView.autoresizingMask = [.flexibleHeight]
       
    }
    
}
