//
//  StockListCell.swift
//  PocketBookTask
//
//  Created by JINGLUO on 25/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit

class StockListCell: UITableViewCell {
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var changeLabel: UILabel!
  @IBOutlet weak var lineView: UIView!

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
      maker.topMargin.equalTo(self.contentView.snp.topMargin).offset(-15)
      maker.bottomMargin.equalTo(self.contentView.snp.bottomMargin).offset(15)
      maker.leadingMargin.equalTo(self.contentView.snp.leadingMargin).offset(15)
      maker.trailingMargin.equalTo(self.contentView.snp.trailingMargin).offset(-15)
    }
    
    nameLabel.snp.makeConstraints { (maker) in
      maker.width.equalTo(priceLabel.snp.width)
    }
    
    changeLabel.snp.makeConstraints { (maker) in
      maker.width.equalTo(self.snp.width).multipliedBy(0.2)
    }
    
    lineView.snp.makeConstraints { (maker) in
      maker.height.equalTo(1)
      maker.topMargin.equalTo(self.contentView.snp.bottomMargin).offset(15)
      maker.leadingMargin.equalTo(self.contentView.snp.leadingMargin)
      maker.trailingMargin.equalTo(self.contentView.snp.trailingMargin)
    }
    
    super.updateConstraints()
  }
  
  func setup(_ stock: StockDetail) {
    
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
  }
  
}
