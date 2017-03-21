//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission noticevarall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import AWSLambda
import AWSCore
import SwiftyJSON
import SwiftCharts
import ActionSheetPicker_3_0

class MainTableViewController: UITableViewController {
    
    //getter and setter for indexPath
    class Index {
        var indexPath: IndexPath = []
        var index: IndexPath {
            get {
                return indexPath
            }
            set {
                indexPath = newValue
            }
        }
    }
    
    //getter and setter for bool
    struct MyVariables {
        static var shouldOpen = true
        
    }
    let tensteps:TenSteps = TenSteps()
    var index = Index()
    var counter = 0
    let kCloseCellHeight: CGFloat = 95
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 30
    var alertCell = DemoCell()
    var cellHeights = [CGFloat]()
    let userDefaults = UserDefaults.standard
    var completionHandlers: [() -> Void] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        MyVariables.shouldOpen = true
        self.createCellHeightsArray()
    }
    
    
    // getter and setter for selected cell
    func setOpenIndex(_ indexPath:IndexPath) {
        index.indexPath = indexPath
    }
    
    func getOpenIndex() -> IndexPath {
        return index.indexPath
    }
    
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    func checkForCellsToBeClosed(_ tableView: UITableView) {
        let visibleIndexPaths = tableView.indexPathsForVisibleRows
        let openedIndex = getOpenIndex()
        if openedIndex != [] {
            let bool = visibleIndexPaths?.contains(openedIndex)
            if bool == false {
                cellHeights[(openedIndex as NSIndexPath).row] = kCloseCellHeight
                MyVariables.shouldOpen = true
                self.setOpenIndex([])
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        let foldingCell = cell as FoldingCell
        foldingCell.backgroundColor = UIColor.clear
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
            foldingCell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            foldingCell.selectedAnimation(true, animated: false, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        self.checkForCellsToBeClosed(tableView)
        cell.stepsLabel.text = tensteps.arrayOfStepNames[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        var duration = 0.0
         let workingCell = tableView.cellForRow(at: indexPath) as! DemoCell
        workingCell.updateSummaryLabel(IndexPath: indexPath)
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            if MyVariables.shouldOpen == true {
                self.setOpenIndex(indexPath)
                MyVariables.shouldOpen = false
                cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
                cell.selectedAnimation(true, animated: true, completion: nil)
                duration = 0.05
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }, completion: nil)
            }
        } else { // close cell
            if MyVariables.shouldOpen == false {
                MyVariables.shouldOpen = true
                cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
                cell.selectedAnimation(false, animated: true, completion: nil)
                duration = 0.05
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                }, completion: {(true) -> Void in
                    tableView.beginUpdates()
                    self.tableView.reloadData()
                    tableView.endUpdates()
                })
            }
        }
    }
}




