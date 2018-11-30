//
//  TruthsViewController.swift
//  Winning
//
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit

class TruthsViewController: UIViewController {
  
  
  @IBOutlet weak var leftView: UIView!
  @IBOutlet weak var rightView: UIView!
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var leftTableSection: UITableView!
  @IBOutlet weak var rightTableSection: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      leftTableSection.delegate = self
      leftTableSection.dataSource = self
      
      rightTableSection.delegate = self
      rightTableSection.dataSource = self
    }
  
  @IBAction func leftButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func rightButtonPressed(_ sender: UIButton) {
  }
}


//MARK: - TableView Extention - Delegate Methods

extension TruthsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    <#code#>
  }
  
  
}
