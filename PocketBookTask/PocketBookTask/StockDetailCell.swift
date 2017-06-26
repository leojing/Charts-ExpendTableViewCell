//
//  stockDetailCell.swift
//  PocketBookTask
//
//  Created by JINGLUO on 25/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit

fileprivate enum CellStatus {
  case expended
  case collapsed
}

class StockDetailCell: UITableViewCell {
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var topStackView: UIStackView!
  @IBOutlet weak var bottomStackView: UIStackView!
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var changeLabel: UILabel!
  
  @IBOutlet weak var openLabel: UILabel!
  @IBOutlet weak var highLabel: UILabel!
  @IBOutlet weak var lowLabel: UILabel!
  @IBOutlet weak var marketLabel: UILabel!
  
  @IBOutlet weak var lineView: UIView!
  
  var isExpanded = false {
    didSet
    {
      if !isExpanded {
        bottomStackView.isHidden = true
        
      } else {
        bottomStackView.isHidden = false
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.updateConstraintsIfNeeded()
  }
  
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  static func reuseId() -> String {
    return String(describing: self)
  }
  
  override func updateConstraints() {
    stackView.snp.makeConstraints { (maker) in
      maker.top.equalTo(self.contentView.snp.top)
      maker.bottom.equalTo(self.contentView.snp.bottom)
      maker.leadingMargin.equalTo(self.contentView.snp.leading)
      maker.trailing.equalTo(self.contentView.snp.trailing)
    }
    
    topStackView.snp.makeConstraints { (maker) in
      maker.height.equalTo(bottomStackView.snp.height)
    }
    
    dateLabel.snp.makeConstraints { (maker) in
      maker.width.equalTo(self.contentView.snp.width).multipliedBy(0.2)
    }
    
    nameLabel.snp.makeConstraints { (maker) in
      maker.width.equalTo(priceLabel.snp.width)
    }
    
    changeLabel.snp.makeConstraints { (maker) in
      maker.width.equalTo(self.contentView.snp.width).multipliedBy(0.2)
    }
    
    lineView.snp.makeConstraints { (maker) in
      maker.height.equalTo(1)
      maker.top.equalTo(self.contentView.snp.bottom).offset(-1)
      maker.leading.equalTo(self.contentView.snp.leading)
      maker.trailing.equalTo(self.contentView.snp.trailing)
    }
    
    super.updateConstraints()
  }
  
  func setup(_ stock: StockDetail) {
    let combined = NSMutableAttributedString()
    combined.append(NSAttributedString(string: "14\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]))
    combined.append(NSAttributedString(string: "JUN", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)]))
    dateLabel.attributedText = combined

    nameLabel.text = stock.symbol
    priceLabel.text = stock.bookValue
    changeLabel.text = stock.change

    if let changeValue = stock.change {
      if Double(changeValue) == 0.0 {
        changeLabel.textColor = UIColor.black
      }
      else if changeValue.characters.first == "-" {
        changeLabel.textColor = UIColor.red
      } else {
        changeLabel.textColor = UIColor.green
      }
    }
    
    if let bookValue = stock.bookValue {
      openLabel.text = "Open\n" + bookValue
    }
    if let high = stock.yearHigh {
      highLabel.text = "High\n" + high
    }
    if let low = stock.yearLow {
      lowLabel.text = "Low\n" + low
    }
    if let low = stock.yearLow {
      marketLabel.text = "MKT CAP\n" + low
    }

  }
  
}
