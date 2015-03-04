//
//  DetailViewController.swift
//  MdevconSpeakers
//
//  Created by Cesare Rocchi on 02/03/15.
//  Copyright (c) 2015 Cesare Rocchi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var presentationTitleLabel: UILabel!
  var detailItem: Speaker? {
    didSet {
        configureView()
    }
  }

  func configureView() {
    nameLabel?.text = detailItem?.name;
    presentationTitleLabel?.text = detailItem?.presentationTitle;
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

