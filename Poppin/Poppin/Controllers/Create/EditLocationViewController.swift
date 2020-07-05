//
//  EditLocationViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/27/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EditLocationViewController: UIViewController, MKMapViewDelegate {
    
    var resultSearchController:UISearchController? = nil
    
   // var addressLookUpLocationSearchTable: LocationSearchTable!

    var campusRegionRadius: CLLocationDistance?
    
    var campusRegion: MKCoordinateRegion?
    
    var locationTapped: Bool?
    
    var streetName: String?
    
    var popsicleImage: UIImage?

    lazy var mainMapView: MKMapView = {
        
        var mainMapView = MKMapView()
        //mainMapView.addGestureRecognizer(mainMenuOutsideTapGestureRecognizer)
        mainMapView.isPitchEnabled = false
        mainMapView.isRotateEnabled = false
        mainMapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mainMapViewRegion)
        mainMapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mainMapView.setRegion(mainMapViewRegion, animated: true)
        mainMapView.delegate = self
        mainMapView.showsUserLocation = false
        //mainMapView.addShadowAndRoundCorners(cornerRadius: 20)
        mainMapView.layer.cornerRadius = 30 
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //longPressRecogniser.minimumPressDuration = 0.01
        tapRecogniser.numberOfTouchesRequired = 1
        mainMapView.addGestureRecognizer(tapRecogniser)
        return mainMapView
        
    }()
    
    lazy private var purpleMapView: UIView = {
        let purpleMapView = UIView()
        purpleMapView.backgroundColor = .mainDARKPURPLE
        purpleMapView.layer.cornerRadius = 30
        return purpleMapView
    }()
    
    lazy private var mainUserLocation: CLLocationCoordinate2D = MapViewController.defaultMapViewCenterLocation
    
    lazy private var mainMapViewRegion: MKCoordinateRegion = {
        
        let mainMapViewRegionCenter = mainUserLocation
        let mainMapViewRegionRadius = MapViewController.defaultMapViewRegionRadius
        
        var mainMapViewRegion = MKCoordinateRegion(center: mainMapViewRegionCenter, latitudinalMeters: mainMapViewRegionRadius, longitudinalMeters: mainMapViewRegionRadius)
        return mainMapViewRegion
        
    }()
    
    lazy var backButton: ImageBubbleButton = {
          let purpleArrow = UIImage(systemName: "arrow.left.circle.fill")!.withTintColor(.mainDARKPURPLE)
          let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
          backButton.contentMode = .scaleToFill
         // backButton.setTitle("Back", for: .normal)
          //backButton.setTitleColor(.newPurple, for: .normal)
          backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
          return backButton
      }()
    
    lazy var confirmLocView: UIView = {
        let confirmLocView = UIView()
        confirmLocView.backgroundColor = .mainDARKPURPLE
        confirmLocView.layer.cornerRadius = 20
        //confirmLocView.isHidden = true
        confirmLocView.alpha = 0.0
        return confirmLocView
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.backgroundColor = .clear
        locationLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 0
        locationLabel.sizeToFit()
       return locationLabel
    }()
    
      lazy var confirmButton: BubbleButton = {
          var confirmButton = BubbleButton(bouncyButtonImage: nil)
          confirmButton.titleLabel!.textAlignment = .center
          confirmButton.titleLabel!.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        confirmButton.backgroundColor = .white
          confirmButton.addTarget(self, action: #selector(confirmLocation), for: .touchUpInside)
          return confirmButton
      }()
    
    lazy var tapLabel: UILabel = {
           let tapLabel = UILabel()
           tapLabel.backgroundColor = .clear
           tapLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title2)
           tapLabel.textAlignment = .center
        tapLabel.text = "Tap on a location!"
           tapLabel.textColor = .mainDARKPURPLE
           tapLabel.numberOfLines = 0
           tapLabel.sizeToFit()
          return tapLabel
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        locationTapped = false
                
        
//        view.addSubview(purpleMapView)
//        purpleMapView.translatesAutoresizingMaskIntoConstraints = false
//        purpleMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        purpleMapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//        purpleMapView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.81).isActive = true
//        purpleMapView.heightAnchor.constraint(equalToConstant: (view.bounds.height * 0.9) - (view.bounds.width * 0.09)).isActive = true
        
        view.addSubview(mainMapView)
        mainMapView.translatesAutoresizingMaskIntoConstraints = false
        mainMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainMapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //mainMapView.topAnchor.constraint(equalTo: purpleMapView.topAnchor, constant: view.bounds.width * 0.015).isActive = true
       // mainMapView.bottomAnchor.constraint(equalTo: purpleMapView.bottomAnchor, constant: -view.bounds.width * 0.015).isActive = true

        mainMapView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        mainMapView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 90)).isActive = true
        
        mainMapView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: mainMapView.topAnchor, constant: view.bounds.height * 0.01).isActive = true
        backButton.leadingAnchor.constraint(equalTo: mainMapView.leadingAnchor, constant: view.bounds.height * 0.01).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        
        mainMapView.addSubview(tapLabel)
        tapLabel.translatesAutoresizingMaskIntoConstraints = false
        tapLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        tapLabel.centerXAnchor.constraint(equalTo: mainMapView.centerXAnchor).isActive = true
//        tapLabel.leadingAnchor.constraint(equalTo: mainMapView.leadingAnchor, constant: view.bounds.height * 0.01).isActive = true
//        tapLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
//        tapLabel.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        
        mainMapView.addSubview(confirmLocView)
        confirmLocView.translatesAutoresizingMaskIntoConstraints = false
        confirmLocView.bottomAnchor.constraint(equalTo: mainMapView.bottomAnchor, constant: -view.bounds.height * 0).isActive = true
        //confirmLocView.topAnchor.constraint(equalTo: mainMapView.bottomAnchor).isActive = true
        confirmLocView.centerXAnchor.constraint(equalTo: mainMapView.centerXAnchor).isActive = true
        confirmLocView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.15).isActive = true
        confirmLocView.widthAnchor.constraint(equalTo: mainMapView.widthAnchor).isActive = true
        confirmLocView.frame.size.height = view.bounds.height * 0.15
        
        confirmLocView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: confirmLocView.topAnchor, constant: view.bounds.height * 0.02).isActive = true
        //confirmLocView.topAnchor.constraint(equalTo: mainMapView.bottomAnchor).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: mainMapView.centerXAnchor).isActive = true
        //locationLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.2).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: mainMapView.widthAnchor).isActive = true
        
        confirmLocView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.bottomAnchor.constraint(equalTo: confirmLocView.bottomAnchor, constant: -view.bounds.height * 0.01).isActive = true
        //confirmLocView.topAnchor.constraint(equalTo: mainMapView.bottomAnchor).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: mainMapView.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func goBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleTap(_ gestureRecognizer : UIGestureRecognizer){
        print("DROP PIN")

        //if gestureRecognizer.state != .began { return }
        //confirmLocView.isHidden = false
        
        

        let touchPoint = gestureRecognizer.location(in: mainMapView)
        let touchMapCoordinate = mainMapView.convert(touchPoint, toCoordinateFrom: mainMapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate

        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mainMapView.setRegion(region, animated: true)
        
       let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: annotation.coordinate.latitude, longitude:annotation.coordinate.longitude)) { (places, error) in
            if error == nil{
                if let place = places{
                   let placemark = place[0]
//                    var text = (placemark.name!) + ", " + (placemark.thoroughfare!)
//                    text += ", "
//                    text += (placemark.subAdministrativeArea!)
//                    text += ", "
//                    text += (placemark.postalCode!)
                    self.streetName = placemark.postalAddress!.street
                    
                    var text = placemark.postalAddress!.street
                    text += ", "
                    text += placemark.postalAddress!.city
                    text += ", "
                    text += placemark.postalAddress!.postalCode
                    
                    
                    self.locationLabel.text = text
                    //here you can get all the info by combining that you can make address
                }
            }
        }
        
        if(!locationTapped!){
            //view.layoutIfNeeded()
            //self.confirmLocView.layer.anchorPoint = CGPoint(x: 0.0,y :0.0)
//            self.confirmLocView.transform = CGAffineTransform(translationX: 0, y: -self.confirmLocView.frame.height)
//
//            self.confirmLocView.alpha = 1.0
            confirmLocView.transform = CGAffineTransform(scaleX: 1, y: 0)
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                 //self.view.layoutIfNeeded()
                
                self.confirmLocView.transform = .identity
                
                //self.confirmLocView.transform = CGAffineTransform(translationX: 0, y: self.confirmLocView.frame.height * 2)
                
                self.confirmLocView.alpha = 1.0
                
                self.view.layoutIfNeeded()
                //self.confirmLocView.frame.size.height += self.view.bounds.height * 0.2
                //self.confirmLocView.origin.y += self.view.bounds.height * 0.2
                //self.confirmLocView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.2).isActive = true


            })
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//                //self.navigationController?.setNavigationBarHidden(true, animated: true)
//                //self.confirmLocView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.2).isActive = true
               //self.confirmLocView.frame.size.height += self.view.bounds.height * 0.2
//                //self.confirmLocView.transform = CGAffineTransform(translationX: 0, y: self.confirmLocView.frame.height)
//                self.confirmLocView.center.y -= self.confirmLocView.frame.height
//
//            })
            
            let allAnnotations = mainMapView.annotations
            mainMapView.removeAnnotations(allAnnotations)
            mainMapView.addAnnotation(annotation)
            locationTapped = true
        }else{
            let allAnnotations = mainMapView.annotations
            mainMapView.removeAnnotations(allAnnotations)
            mainMapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"

        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = popsicleImage

            // if you want a disclosure button, you'd might do something like:
            //
            // let detailButton = UIButton(type: .detailDisclosure)
            // annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    @objc func confirmLocation(){
        self.dismiss(animated: true, completion: nil)
        let textInfo = ["street": streetName!, "address": locationLabel.text!, "location": mainMapView.annotations[0].coordinate ] as [String : Any]
        NotificationCenter.default.post(name: .locationSelected, object: nil, userInfo: textInfo as [AnyHashable : Any])
    }
    
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {

//          var i = -1;
          for view in views {
//              i += 1;
//              if view.annotation is MKUserLocation {
//                  continue;
//              }
//
//              // Check if current annotation is inside visible map rect, else go to next one
//            let point:MKMapPoint  =  MKMapPoint(view.annotation!.coordinate);
//            if (!self.mainMapView.visibleMapRect.contains(point)) {
//                  continue;
//              }

              let endFrame:CGRect = view.frame;

              // Move annotation out of view
              view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,y :view.frame.origin.y-self.view.frame.size.height), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))

              // Animate drop
              //let delay = 0.03 * Double(i)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations:{() in
                view.frame = endFrame
                  // Animate squash
                  }, completion:{(Bool) in
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                        view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)

                          }, completion: {(Bool) in
                            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                                view.transform = CGAffineTransform.identity
                                  }, completion: nil)
                      })

              })
          }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
