//
//  ViewController.swift
//  Practice
//
//  Created by Yu-Chun Hsu on 2022/11/15.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UICollectionView!
    
    static let CellCount = 10
    let colors: [UIColor] = {
        return (1...CellCount).map { _ in
            return UIColor(red: Double.random(in: 0...255)/255.0, green: Double.random(in: 0...255)/255.0, blue: Double.random(in: 0...255)/255.0, alpha: 1.0)
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getVisibleRect(indexPath: IndexPath) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(indexPath.item) * UIScreen.main.bounds.size.width, y: 0), size: UIScreen.main.bounds.size)
    }
}

extension ViewController: SwipeViewCellDelegate {
    func didSwipeLeft() {
        
        for cell in scrollView.visibleCells {
            
            if let indexPath = scrollView.indexPath(for: cell) {
                let newIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                scrollView.scrollRectToVisible(getVisibleRect(indexPath: newIndexPath), animated: true)
                break
            }
        }
        
    }
    
    func didSwifeRight() {
        for cell in scrollView.visibleCells {
            if let indexPath = scrollView.indexPath(for: cell) {
                let newIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                scrollView.scrollRectToVisible(getVisibleRect(indexPath: newIndexPath), animated: true)
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipeViewCell", for: indexPath) as! SwipeViewCell
        cell.setup()
        cell.customView.backgroundColor = colors[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.CellCount
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
