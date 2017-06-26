//
//  StockListViewController.swift
//  PocketBookTask
//
//  Created by JINGLUO on 24/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit

class StockListViewController: UIViewController {

  struct Constants {
    struct Segue {
      static let showDetailSegue = "showStockDetail"
    }
  }

  @IBOutlet weak var tableView: UITableView!
  
  fileprivate let networkManager = NetworkManager()
  fileprivate let stockList = ["APPL", "GOOG", "YHOO", "DOW", "FTSE"]
  fileprivate var stockDetailList = [StockDetail]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUp()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func updateViewConstraints() {
     makeConstraints()
     super.updateViewConstraints()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.Segue.showDetailSegue {
      let controller = segue.destination as! StockDetailViewController
      controller.stockDetail = sender as? StockDetail
    }
  }
}

// MARK: - update constraints

extension StockListViewController {
  
  fileprivate func makeConstraints() {
    tableView.snp.makeConstraints { (maker) in
      maker.topMargin.equalTo(self.view.snp.topMargin).offset(10)
      maker.bottom.equalTo(self.view.snp.bottom)
      maker.leadingMargin.equalTo(self.view.snp.leadingMargin)
      maker.trailingMargin.equalTo(self.view.snp.trailingMargin)
    }
  }
}

// MARK: - set up

extension StockListViewController {
  
  fileprivate func setUp() {
    setupTableView()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 80.0
    tableView.register(StockListCell.nib(), forCellReuseIdentifier: StockListCell.reuseId())
    
    prepareTableViewDatasource()
  }
  
  private func prepareTableViewDatasource() {
    let newStockList = stockList.map {
      return StockDetail(symbol: $0, bookValue: nil, change: nil, yearLow: nil, yearHigh: nil)
    }
    
    stockDetailList = newStockList
    if stockDetailList.count > 0 {
      tableView.reloadData()
    }
    
    let _ = newStockList.enumerated().map { (index, stockDetail) in
      DispatchQueue.global().async(execute: { [weak self] in
        self?.networkManager.getDataWithStockId(stockDetail.symbol, index: index, completionHandler: { (json, error, index) in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
          
          guard let json = json else {
            print("Error: No data")
            return
          }
          if let info = StockDetail(json) {
            self?.stockDetailList[index] = info
            DispatchQueue.main.async {
              self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
            }
          }
        })
      })
    }
  }
}


// MARK: - UITableViewDataSource

extension StockListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stockDetailList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.reuseId(), for: indexPath) as! StockListCell
    let data = stockDetailList[indexPath.row]
    cell.setup(data)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension StockListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let stockDetail = stockDetailList[indexPath.row]
    guard let _ = stockDetail.bookValue, let _ = stockDetail.change else {
      let alert = UIAlertController(title: "Loading stock data, please wait!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler:nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    performSegue(withIdentifier: Constants.Segue.showDetailSegue, sender: stockDetail)
  }
}

