//
//  StockDetailViewController.swift
//  PocketBookTask
//
//  Created by JINGLUO on 24/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import Charts

class StockDetailViewController: UIViewController {

  @IBOutlet weak var currentPriceLabel: UILabel!
  @IBOutlet weak var movementLabel: UILabel!
  @IBOutlet weak var chartView: LineChartView!
  @IBOutlet weak var tableView: UITableView!
  
  public var stockDetail: StockDetail?
  fileprivate var expandedRows = Set<Int>()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = stockDetail?.symbol
    setUp()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateConstraints()
  }
  
  override func updateViewConstraints() {
    makeConstraints()
    super.updateViewConstraints()
  }
}

// MARK: - update constraints

extension StockDetailViewController {
  
  fileprivate func makeConstraints() {
    let labelWidth = 120
    currentPriceLabel.snp.makeConstraints { (maker) in
      maker.height.equalTo(50)
      maker.width.equalTo(labelWidth)
      maker.centerX.equalToSuperview().offset(-20-labelWidth/2)
      let topOffset = UIDevice.current.orientation.isPortrait ? 40 : 15
      maker.topMargin.equalTo(self.topLayoutGuide.snp.bottom).offset(topOffset)
    }
    
    movementLabel.snp.makeConstraints { (maker) in
      maker.height.equalTo(currentPriceLabel.snp.height)
      maker.width.equalTo(currentPriceLabel.snp.width)
      maker.topMargin.equalTo(currentPriceLabel.snp.topMargin)
      maker.centerX.equalToSuperview().offset(20+labelWidth/2)
    }
    
    chartView.snp.makeConstraints { (maker) in
      maker.top.equalTo(currentPriceLabel.snp.bottom).offset(15)
      maker.centerX.equalToSuperview()
      let width = UIDevice.current.orientation.isPortrait ? self.view.frame.width * 0.8 : 200
      maker.width.equalTo(width)
      maker.height.equalTo(chartView.snp.width).multipliedBy(1)
    }
    
    tableView.snp.makeConstraints { (maker) in
      maker.top.equalTo(chartView.snp.bottom).offset(20)
      maker.bottom.equalTo(self.view.snp.bottom)
      maker.leadingMargin.equalTo(self.view.snp.leadingMargin)
      maker.trailingMargin.equalTo(self.view.snp.trailingMargin)
    }
  }
  
  fileprivate func updateConstraints() {
    currentPriceLabel.snp.updateConstraints { (maker) in
      let topOffset = UIDevice.current.orientation.isPortrait ? 40 : 15
      maker.topMargin.equalTo(self.topLayoutGuide.snp.bottom).offset(topOffset)
    }
    
    chartView.snp.updateConstraints { (maker) in
      let width = UIDevice.current.orientation.isPortrait ? self.view.frame.width * 0.8 : 200
      maker.width.equalTo(width)
    }
  }
}

// MARK: - set up

extension StockDetailViewController {
  
  fileprivate func setUp() {
    setUpTopLabels()
    setUpChart()
    setupTableView()
  }

  private func setUpTopLabels() {
    currentPriceLabel.layer.masksToBounds = true
    currentPriceLabel.layer.cornerRadius = 5
    if let price = stockDetail?.bookValue {
      let combined = NSMutableAttributedString()
      combined.append(NSAttributedString(string: "CURRENT PRICE\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 13)]))
      combined.append(NSAttributedString(string: price, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]))
      currentPriceLabel.attributedText = combined
    }

    
    movementLabel.layer.masksToBounds = true
    movementLabel.layer.cornerRadius = 5
    if let change = stockDetail?.change {
      var attributeColor: UIColor = (change.characters.first == "-") ? .red : .green
      if Double(change) == 0 {
        attributeColor = .black
      }
      let combined = NSMutableAttributedString()
      combined.append(NSAttributedString(string: "MOVEMENT\n", attributes: [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 13)]))
      combined.append(NSAttributedString(string: change, attributes: [NSForegroundColorAttributeName : attributeColor, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]))
      movementLabel.attributedText = combined
    }
  }
  
  private func setUpChart() {
    //TODO: entries with fake data
    var dataEntries: [ChartDataEntry] = []
    let prices = [0.5, 1.8, 2.6, 2.3]
    for i in 0..<4 {
      if let bookValue = stockDetail?.bookValue {
        let dataEntry = ChartDataEntry(x: Double(i), y: Double(bookValue)!+prices[i])
        dataEntries.append(dataEntry)
      }
    }
    let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
    chartDataSet.colors = [UIColor.gray]
    chartDataSet.setCircleColor(UIColor.white)
    chartDataSet.circleHoleColor = UIColor.gray
    chartDataSet.circleRadius = 6.0
    chartDataSet.mode = .cubicBezier
    chartDataSet.cubicIntensity = 0.2
    chartDataSet.drawCirclesEnabled = true
    chartDataSet.fillColor = UIColor.gray
    chartDataSet.fillAlpha = 1.0
    chartDataSet.drawFilledEnabled = true

    let chartData = LineChartData(dataSet: chartDataSet)
    chartData.setDrawValues(false)
    
    chartView.data = chartData
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(StockDetailCell.nib(), forCellReuseIdentifier: StockDetailCell.reuseId())
  }
}

// MARK: - UITableViewDataSource

extension StockDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if self.expandedRows.contains(indexPath.row) {
      return 120.0
    }
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // TODO: fake data
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StockDetailCell.reuseId(), for: indexPath) as! StockDetailCell
    // TODO: fake data
    if let data = stockDetail {
      cell.setup(data)
    }
    cell.isExpanded = self.expandedRows.contains(indexPath.row)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension StockDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? StockDetailCell
      else { return }
    
    switch cell.isExpanded {
      case true:
        self.expandedRows.remove(indexPath.row)
      
      case false:
        self.expandedRows.insert(indexPath.row)
    }
    
    cell.isExpanded = !cell.isExpanded
    
    self.tableView.beginUpdates()
    self.tableView.endUpdates()
  }
}

