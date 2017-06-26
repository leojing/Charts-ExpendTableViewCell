//
//  ViewController.swift
//  PocketBookTask
//
//  Created by JINGLUO on 24/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    nextButton.layer.masksToBounds = true
    nextButton.layer.cornerRadius = 25
  }
  
  override func viewWillAppear(_ animated: Bool) {
    logoImageView.startRotating()
    self.navigationController?.navigationBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    logoImageView.stopRotating()
    self.navigationController?.navigationBar.isHidden = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func updateViewConstraints() {
    nameLabel.snp.makeConstraints { (maker) in
      maker.center.equalToSuperview()
    }
    
    logoImageView.snp.makeConstraints { (maker) in
      maker.centerX.equalToSuperview()
      maker.bottom.equalTo(nameLabel.snp.top).offset(-40)
    }
    
    descriptionLabel.snp.makeConstraints { (maker) in
      maker.centerX.equalToSuperview()
      maker.width.equalTo(self.view.snp.width).multipliedBy(0.7)
      maker.top.equalTo(nameLabel.snp.bottom).offset(10)
    }
    
    nextButton.snp.makeConstraints { (maker) in
      maker.centerX.equalToSuperview()
      maker.width.equalTo(self.view.snp.width).multipliedBy(0.8)
      maker.bottom.equalTo(self.view.snp.bottom).offset(-50)
      maker.height.equalTo(50)
    }
    super.updateViewConstraints()
  }
}

extension UIView {
  
   func startRotating(duration: Double = 3) {
    let kAnimationKey = "rotation"
    
    if self.layer.animation(forKey: kAnimationKey) == nil {
      let animate = CABasicAnimation(keyPath: "transform.rotation")
      animate.duration = duration
      animate.repeatCount = Float.infinity
      animate.fromValue = 0.0
      animate.toValue = Float(.pi * 2.0)
      self.layer.add(animate, forKey: kAnimationKey)
    }
  }
  
  func stopRotating() {
    let kAnimationKey = "rotation"
    
    if self.layer.animation(forKey: kAnimationKey) != nil {
      self.layer.removeAnimation(forKey: kAnimationKey)
    }
  }
}

