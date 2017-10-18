//
//  LogCollectionViewController.swift
//  myHome
//
//  Created by Johnny Zhang on 2/12/17.
//  Copyright © 2017 Johnny Zhang. All rights reserved.
//

import UIKit

private let cellID = "Cell"

class LogCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    
    @objc public var commandArray = [String]()
    

   
    @objc func handleRightEdgeSwipe(gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized{
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionFade
            transition.subtype = kCATransitionFromRight
            self.navigationController?.view.layer.add(transition, forKey: nil)
            let _ = self.navigationController?.popToRootViewController(animated: false)
            print("right swipped")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.view.layoutIfNeeded()
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        if item > 0 {
            let lastItemIndex = NSIndexPath(item: item, section: 0) as IndexPath
            self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.bottom, animated: false)
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionViewLayout.invalidateLayout()
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let rightEdgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightEdgeSwipe(gesture:)))
        rightEdgeSwipe.edges = .right
        view.addGestureRecognizer(rightEdgeSwipe)
        
        collectionView?.backgroundColor = UIColor.black
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: cellID)        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return commandArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LogCell
        
        // Configure the cell
        
        cell.logTextView.text = commandArray[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commandText = commandArray[indexPath.row]
        if commandText != "" {
            let size = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: commandText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 26)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
}

class LogCell: BaseCell {
    
    @objc let logTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 26)
        textView.text = ""
        textView.textColor = UIColor.green
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func setupView() {
        backgroundColor = UIColor.clear
        addSubview(logTextView)
        setupLogTextViewConstraints()
        
    }
    
    @objc func setupLogTextViewConstraints() {
        addConstraintsWithFormat(format: "H:|[v0]|", views: logTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: logTextView)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setupView() {}
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...)  {
        var viewDics = [String: UIView]()
        for (index, uiview) in views.enumerated() {
            let key = "v\(index)"
            viewDics[key] = uiview
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDics))
    }
}



