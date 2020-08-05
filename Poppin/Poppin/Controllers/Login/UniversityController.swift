//
//  UniversityController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import CoreLocation

enum UniversityError: String, Error {
    
    case attributeHasBeenSet = "Attribute has already been set and cannot be set again."
    case invalidParameter = "Parameter passed is invalid."
    case attributeHasNotBeenSet = "Attribute not been set yet (nil)."
    
}

final class UniversityController: NSObject {
    
    private var university: UniversityModel = UniversityModel()
    
    override init() {
        
        super.init()
        
    }
    
    init(universityModel: UniversityModel) {
        
        super.init()
        
        merge(with: universityModel)
        
    }
    
    init(universityController: UniversityController) {
        
        super.init()
        
        merge(with: universityController)
        
    }
    
    static func == (lhs: UniversityController, rhs: UniversityController) -> Bool {
        
        var lhsId: String? = nil
        var rhsId: String? = nil
        
        var errorLog: String = "Universiy Error log: \n"
        
        do { try lhsId = lhs.getId() } catch let error as UniversityError { errorLog.append("lhs id: " + error.rawValue + "\n") } catch { errorLog.append("lhs id: " + error.localizedDescription + "\n") }
        do { try rhsId = rhs.getId() } catch let error as UniversityError { errorLog.append("rhs id: " + error.rawValue + "\n") } catch { errorLog.append("rhs id: " + error.localizedDescription + "\n") }
        
        print(errorLog)
        
        if lhsId == nil || rhsId == nil { return false }
        
        return lhsId == rhsId
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
    
        if let other = object as? UniversityController {
         
            var id: String? = nil
            var otherId: String? = nil
            
            var errorLog: String = "University Error log: \n"
            
            do { try id = self.getId() } catch let error as UniversityError { errorLog.append("self id: " + error.rawValue + "\n") } catch { errorLog.append("self id: " + error.localizedDescription + "\n") }
            do { try otherId = other.getId() } catch let error as UniversityError { errorLog.append("other id: " + error.rawValue + "\n") } catch { errorLog.append("other id: " + error.localizedDescription + "\n") }
            
            print(errorLog)
            
            if id == nil || otherId == nil { return false }
            
            return id == otherId
            
        } else {
            
            return false
            
        }
        
    }
    
    func merge(with universityController: UniversityController) {
        
        var errorLog: String = "University error log: \n"
        
        do { try setId(id: try universityController.getId()) } catch let error as UniversityError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { try setName(name: try universityController.getName()) } catch let error as UniversityError { errorLog.append("name: " + error.rawValue + "\n") } catch { errorLog.append("name: " + error.localizedDescription + "\n") }
        do { try setDomain(domain: try universityController.getDomain()) } catch let error as UniversityError { errorLog.append("domain: " + error.rawValue + "\n") } catch { errorLog.append("domain: " + error.localizedDescription + "\n") }
        do { try setRadius(radius: try universityController.getRadius()) } catch let error as UniversityError { errorLog.append("radius: " + error.rawValue + "\n") } catch { errorLog.append("radius: " + error.localizedDescription + "\n") }
        do { try setLocation(location: try universityController.getLocation()) } catch let error as UniversityError { errorLog.append("location: " + error.rawValue + "\n") } catch { errorLog.append("location: " + error.localizedDescription + "\n") }
        
        if errorLog == "University error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func merge(with universityModel: UniversityModel) {
        
        var errorLog: String = "University error log: \n"
        
        do { if let id = universityModel.id { try setId(id: id) } } catch let error as UniversityError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { if let name = universityModel.name { try setName(name: name) } } catch let error as UniversityError { errorLog.append("name: " + error.rawValue + "\n") } catch { errorLog.append("name: " + error.localizedDescription + "\n") }
        do { if let domain = universityModel.domain { try setDomain(domain: domain) } } catch let error as UniversityError { errorLog.append("domain: " + error.rawValue + "\n") } catch { errorLog.append("domain: " + error.localizedDescription + "\n") }
        do { if let radius = universityModel.radius { try setRadius(radius: radius) } } catch let error as UniversityError { errorLog.append("radius: " + error.rawValue + "\n") } catch { errorLog.append("radius: " + error.localizedDescription + "\n") }
        do { if let location = universityModel.location { try setLocation(location: location) } } catch let error as UniversityError { errorLog.append("location: " + error.rawValue + "\n") } catch { errorLog.append("location: " + error.localizedDescription + "\n") }
        
        if errorLog == "University error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func setId(id: String) throws {
        
        if id.isEmpty { throw UniversityError.invalidParameter }
            
        if university.id != nil { throw UniversityError.attributeHasBeenSet }
        
        university.id = id
        
    }
    
    func setName(name: String) throws {
        
        if name.isEmpty { throw UniversityError.invalidParameter }
        
        university.name = name
        
    }
    
    func setDomain(domain: String) throws {
        
        if domain.isEmpty { throw UniversityError.invalidParameter }
        
        university.domain = domain
        
    }
    
    func setRadius(radius: CGFloat) throws {
        
        if radius <= 0.0 { throw UniversityError.invalidParameter }
        
        university.radius = radius
        
    }
    
    func setLocation(location: CLLocationCoordinate2D) throws {
        
        university.location = location
        
    }
    
    func getId() throws -> String {
        
        guard let id = university.id else { throw UniversityError.attributeHasNotBeenSet }
        
        return id
        
    }
    
    func getName() throws -> String {
        
        guard let name = university.name else { throw UniversityError.attributeHasNotBeenSet }
        
        return name
        
    }
    
    func getDomain() throws -> String {
        
        guard let domain = university.domain else { throw UniversityError.attributeHasNotBeenSet }
        
        return domain
        
    }
    
    func getRadius() throws -> CGFloat {
        
        guard let radius = university.radius else { throw UniversityError.attributeHasNotBeenSet }
        
        return radius
        
    }
    
    func getLocation() throws -> CLLocationCoordinate2D {
        
        guard let location = university.location else { throw UniversityError.attributeHasNotBeenSet }
        
        return location
        
    }
    
    func rawValue() -> UniversityModel {
        
        return university
        
    }
    
}

