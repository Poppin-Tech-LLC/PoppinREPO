//
//  CreatePopsicleViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 5/13/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class CreatePopsicleViewController : UIViewController {
    
    lazy private var cancelButton: BubbleButton = {
        var cb = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .multiply, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .medium)).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal))
        cb.backgroundColor = .white
        cb.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 2), left: .getPercentageWidth(percentage: 2), bottom: .getPercentageWidth(percentage: 2), right: .getPercentageWidth(percentage: 2))
        cb.addTarget(self, action: #selector(dismissCreateEvent), for: .touchUpInside)
        return cb
    }()
    
    @objc func dismissCreateEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var gLayer : CAGradientLayer = {
        let g = CAGradientLayer()
        g.type = .radial
        g.colors = [ UIColor.white.cgColor,
                     UIColor.purple.cgColor]
        g.locations = [ 0 , 1 ]
        g.startPoint = CGPoint(x: 0.5, y: 0.5)
        g.endPoint = CGPoint(x: 1.4, y: 1.15)
        g.frame = view.layer.bounds
        return g
    }()
    
    lazy var categoryCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .getPercentageWidth(percentage: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor(white: 1, alpha: 0.0)
        cv.dataSource = self
        cv.delegate = self
        //cv.isPagingEnabled = true
        //cv.contentInsetAdjustmentBehavior = .always
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // content padding so first cell appears in center of screen
        let leftPadding = CGFloat.getPercentageWidth(percentage: 25)
        let rightPadding = leftPadding
        
        cv.contentInset = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        
        // hide the scroll indicator
        cv.showsHorizontalScrollIndicator = false
        return cv
        
    }()
    
    let cellReuseIdentifier = "cell"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // gradient
        view.layer.insertSublayer(gLayer, at: 0)
        
        // collection view
        view.addSubview(categoryCollectionView)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 100)).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 30)).isActive = true
        categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 30)).isActive = true
        categoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // cancel button
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 2)).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 5)).isActive = true
    }
    
}

extension NewCreateEventViewController : UICollectionViewDataSource {
    // hardcode to show 10 cells, you can use array for this if you want
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CollectionViewCell
        switch (indexPath.row)   {
          case 0:
            //cell.contentView.backgroundColor = .purple
            cell.pImage.image = UIImage(named: "showsButton")
          case 1:
            //cell.contentView.backgroundColor = .red
            cell.pImage.image = UIImage(named: "educationButton")
          case 2:
            //cell.contentView.backgroundColor = .orange
            cell.pImage.image = UIImage(named: "foodButton")
          case 3:
            //cell.contentView.backgroundColor = .yellow
            cell.pImage.image = UIImage(named: "socialButton")
          case 4:
            //cell.contentView.backgroundColor = .green
            cell.pImage.image = UIImage(named: "sportsButton")
        default:
           break
         }
        return cell
    }
}

// Cell height is equal to the collection view's height
// Cell width = cell height = collection view's height
extension NewCreateEventViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .getPercentageWidth(percentage: 50), height: collectionView.frame.size.height)
    }
    
}

extension NewCreateEventViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

        // controls what happens when a card is clicked
        let vc = NewCreateEventCardViewController()
     switch (indexPath.row)   {
         case 0:
            print("0")
            vc.backgroundGradientColors = [ UIColor.white.cgColor, UIColor.purple.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 1:
            print("1")
            vc.backgroundGradientColors = [ UIColor.white.cgColor, UIColor.red.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 2:
            print("2")
            vc.backgroundGradientColors = [ UIColor.white.cgColor, UIColor.orange.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 3:
            print("3")
            vc.backgroundGradientColors = [ UIColor.white.cgColor, UIColor.yellow.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 4:
            print("4")
            vc.backgroundGradientColors = [ UIColor.white.cgColor, UIColor.green.cgColor ]
            self.present(vc, animated: true, completion: nil)
       default:
          break
        }

    }
    
}

extension NewCreateEventViewController : UIScrollViewDelegate {
    
    // perform scaling whenever the collection view is being scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // center X of collection View
        let centerX = self.categoryCollectionView.center.x
    
        // only perform the scaling on cells that are visible on screen
        for cell in self.categoryCollectionView.visibleCells {
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + self.categoryCollectionView.frame.size.height / 2.0
            
            let distance = abs(cellCenterX - centerX)
            
            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerX ) * 0.105)
            if(scale > 1.0){
                scale = 1.0
            }
            
            // set minimum scale so the previous and next album art will have the same size
            if(scale < 0.860091){
                scale = 0.860091
            }
            
            // Transform the cell size based on the scale
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // change the alpha of the image view
            let coverCell = cell as! CollectionViewCell
            coverCell.contentView.alpha = changeSizeScaleToAlphaScale(scale)
        }
    }
    
    // map the scale of cell size to alpha of image view using formula below
    // https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
    func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
    }
    
    // for custom snap-to paging, when user stop scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        var indexOfCellWithLargestWidth = 0
        var largestWidth : CGFloat = 1
        
        for cell in self.categoryCollectionView.visibleCells {
            if cell.frame.size.width > largestWidth {
                largestWidth = cell.frame.size.width
                if let indexPath = self.categoryCollectionView.indexPath(for: cell) {
                    indexOfCellWithLargestWidth = indexPath.item
                }
            }
        }

        categoryCollectionView.scrollToItem(at: IndexPath(item: indexOfCellWithLargestWidth, section: 0), at: .centeredHorizontally, animated: true)
        
        var bColor = UIColor()
        switch (indexOfCellWithLargestWidth)   {
          case 0:
             bColor = UIColor.purple
          case 1:
             bColor = UIColor.red
          case 2:
             bColor = UIColor.orange
          case 3:
             bColor = UIColor.yellow
          case 4:
             bColor = UIColor.green
        default:
           break
         }

        let newColors = [ UIColor.white.cgColor, bColor.cgColor]
        
        // gradient color change animation
        let colorsAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorsAnimation.fromValue = gLayer.colors
        colorsAnimation.toValue = newColors
        colorsAnimation.duration = 4.0
        colorsAnimation.delegate = self
        colorsAnimation.fillMode = .forwards
        colorsAnimation.isRemovedOnCompletion = false
        
        gLayer.add(colorsAnimation, forKey: "colors")
        gLayer.colors = newColors
    }

}

class CollectionViewCell : UICollectionViewCell {
    
    lazy var pImage : UIImageView = {
        return UIImageView()
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 2
        
        contentView.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 19)).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 8.5)).isActive = true
        pImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 2)).isActive = true
        pImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewCreateEventViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            print("animation finished")
        }
    }
}

