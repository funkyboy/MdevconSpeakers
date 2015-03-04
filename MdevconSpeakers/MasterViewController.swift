//
//  MasterViewController.swift
//  MdevconSpeakers
//
//  Created by Cesare Rocchi on 02/03/15.
//  Copyright (c) 2015 Cesare Rocchi. All rights reserved.
//

import UIKit
import WebKit

let MESSAGE_HANDLER = "didFetchSpeakers"
let ONLINE = true

class MasterViewController: UITableViewController, WKScriptMessageHandler {
  
  var speakers:[Speaker] = []
  var speakersWebView: WKWebView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    title = "Speakers"
    
    //1. Create empty configuration
    let speakersWebViewConfiguration = WKWebViewConfiguration()
    //2. Load JavaScript code
    let scriptURL = NSBundle.mainBundle().pathForResource("fetchSpeakers", ofType: "js")
    let jsScript = String(contentsOfFile:scriptURL!, encoding:NSUTF8StringEncoding, error: nil)
    //3. Wrap JavaScript code in a user script
    let fetchAuthorsScript = WKUserScript(source: jsScript!, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
    //4. Add script to configuration's controller
    speakersWebViewConfiguration.userContentController.addUserScript(fetchAuthorsScript)
    //5. Subscribe to listen for a callback from the web view
    speakersWebViewConfiguration.userContentController.addScriptMessageHandler(self, name: MESSAGE_HANDLER)
    //6. Create web view with configuration
    speakersWebView = WKWebView(frame: CGRectZero, configuration: speakersWebViewConfiguration)
    var speakersURL = NSURL(string:"http://speakers.dev/webarchive-index.html");
    if (ONLINE) {
      println("We are online")
      speakersURL = NSURL(string:"http://mdevcon.com/posts/category/speakers/");
    }
    println("URL \(speakersURL)")
    let speakersRequest = NSURLRequest(URL:speakersURL!)
    //7. Set up KVO
    speakersWebView!.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
    speakersWebView!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    //8. Load request
    speakersWebView!.loadRequest(speakersRequest)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    
    if (message.name == MESSAGE_HANDLER) {
      if let resultArray = message.body as? [NSDictionary] { // Weak spot
        for d in resultArray {
          let speaker = Speaker(dictionary: d)
          speakers.append(speaker);
        }
      }
      tableView.reloadData()
    }
    
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
    
    switch keyPath {
      
    case "loading":
      UIApplication.sharedApplication().networkActivityIndicatorVisible = speakersWebView!.loading
      
    case "estimatedProgress":
      println("progress \(speakersWebView!.estimatedProgress)")
      
    default:
      println("unknown key")
      
    }
    
  }
  
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow() {
        let speaker = speakers[indexPath.row]
        (segue.destinationViewController as DetailViewController).detailItem = speaker
      }
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return speakers.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    let speaker = speakers[indexPath.row]
    cell.textLabel!.text = speaker.name
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
}

