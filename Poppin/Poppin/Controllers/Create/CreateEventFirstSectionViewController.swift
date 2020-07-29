//
//  CreateEventFirstSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/27/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType()
        
    }
    
    
    func updateUIViewController(_ uiViewController: CreateEventFirstSectionViewController, context: Context) {}
    
    typealias UIViewControllerType = CreateEventFirstSectionViewController
    
}

struct TestPreview: PreviewProvider {
    
    static var previews: Previews {
        
        return Preview()
        
    }
    
    typealias Previews = Preview
    
}

final class CreateEventFirstSectionViewController: UIViewController {
    
    private var eventController = EventController()
    private var currentPage: Int = 0
    
    override func loadView() {
        
        self.view = CreateEventFirstSectionView()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        view.categoryPickerCollectionView.delegate = self
        view.categoryPickerCollectionView.dataSource = self
        view.closeButton.addTarget(self, action: #selector(dismissCreateEventPage), for: .touchUpInside)
        view.visibilitySwitch.addTarget(self, action: #selector(visibilityChanged(sender:)), for: .valueChanged)
        
    }
    
    @objc private func dismissCreateEventPage() {
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func visibilityChanged(sender: UISwitch) {
        
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        if sender.isOn {
            
            UIView.transition(with: view.visibilityCountLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityCountLabel.text = "10 left"
                
            }, completion: nil)
            
        } else {
            
            UIView.transition(with: view.visibilityCountLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityCountLabel.text = "Unlimited"
                
            }, completion: nil)
            
            
        }
        
    }
    
}

extension CreateEventFirstSectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return EventCategory.allCases.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.defaultReuseIdentifier, for: indexPath) as? CategoryViewCell {
            
            categoryCell.popsicleIconImageView.image = EventCategory.allCases[indexPath.row].getPopsicleIcon256()
            categoryCell.categoryLabel.text = EventCategory.allCases[indexPath.row].rawValue
            categoryCell.descriptionLabel.text = EventCategory.allCases[indexPath.row].getDescription()
            
            guard let view = view as? CreateEventFirstSectionView else { return categoryCell }
            
            categoryCell.containerStackView.anchor(centerX: categoryCell.contentView.centerXAnchor, size: CGSize(width: view.titleLabel.intrinsicContentSize.width, height: 0.0))
            
            return categoryCell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        do {
            
            try eventController.setCategory(category: EventCategory.allCases[indexPath.row])
            
            //print("Event Category: ", try eventController.getCategory())
            
            try eventController.setPublic(isPublic: view.visibilitySwitch.isOn)
            
            //print("Event isPublic: ", eventController.isPublic())
            
            // Segue To Next Section
            
        } catch let error as EventError {
            
            print(error.rawValue)
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: { [weak self] in
            
                guard let self = self else { return }
                
                self.navigationController?.popToRootViewController(animated: true)
            
            })
            
            let alertVC = AlertViewController(alertTitle: "Unable to proceed", alertMessage: "An error occured. Please try again.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } catch {
            
            print(error.localizedDescription)
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: { [weak self] in
            
                guard let self = self else { return }
                
                self.navigationController?.popToRootViewController(animated: true)
            
            })
            
            let alertVC = AlertViewController(alertTitle: "Unable to proceed", alertMessage: "An error occured. Please try again.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        let pageOffset = scrollView.contentOffset.x / view.frame.width
        
        if pageOffset >= 0.0, pageOffset < CGFloat(EventCategory.allCases.count) {
            
            let minOffset = CGFloat(currentPage) - 0.5
            let maxOffset = CGFloat(currentPage) + 0.5
            
            if pageOffset < minOffset {
                
                currentPage-=1
                
                UIView.transition(with: view.backgroundImageView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { view.backgroundImageView.image = EventCategory.allCases[self.currentPage].getGradientBackground() },
                completion: nil)
                
                UIView.transition(with: view.pageMarkerStackView.arrangedSubviews[currentPage],
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { (view.pageMarkerStackView.arrangedSubviews[self.currentPage] as! UIImageView).image = UIImage.filledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal) },
                completion: nil)
                
                UIView.transition(with: view.pageMarkerStackView.arrangedSubviews[currentPage+1],
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { (view.pageMarkerStackView.arrangedSubviews[self.currentPage+1] as! UIImageView).image = UIImage.nonFilledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal) },
                completion: nil)
                
            } else if pageOffset > maxOffset {
                
                currentPage+=1
                
                UIView.transition(with: view.backgroundImageView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { view.backgroundImageView.image = EventCategory.allCases[self.currentPage].getGradientBackground() },
                completion: nil)
                
                UIView.transition(with: view.pageMarkerStackView.arrangedSubviews[currentPage],
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { (view.pageMarkerStackView.arrangedSubviews[self.currentPage] as! UIImageView).image = UIImage.filledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal) },
                completion: nil)
                
                UIView.transition(with: view.pageMarkerStackView.arrangedSubviews[currentPage-1],
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { (view.pageMarkerStackView.arrangedSubviews[self.currentPage-1] as! UIImageView).image = UIImage.nonFilledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal) },
                completion: nil)
                
            }
            
        }
        
        // center X of collection View
        let centerX = view.categoryPickerCollectionView.center.x
        
        // only perform the scaling on cells that are visible on screen
        for cell in view.categoryPickerCollectionView.visibleCells {
            
            guard let cell = cell as? CategoryViewCell else { continue }
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + view.categoryPickerCollectionView.frame.size.width / 2.0
            
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
            let coverCell: CategoryViewCell = cell
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
    
}
