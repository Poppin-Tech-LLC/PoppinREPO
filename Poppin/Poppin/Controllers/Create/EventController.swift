//
//  EventController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/27/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import Kronos
import SwiftDate
import CoreLocation

enum EventError: String, Error {
    
    case nonEditable = "Event cannot be edited."
    case attributeHasBeenSet = "Attribute has already been set and cannot be set again."
    case invalidParameter = "Parameter passed is invalid."
    case onlineClockNotAvailable = "Online clock is not available."
    case unableToRemoveParameter = "Unable to remove value with the id passed."
    case attributeHasNotBeenSet = "Attribute not been set yet (nil)."
    
}

final class EventController: NSObject {
    
    private var event: EventModel = EventModel()
    
    override init() {
        
        super.init()
        
    }
    
    init(eventModel: EventModel) {
        
        super.init()
        
        merge(with: eventModel)
        
    }
    
    init(eventController: EventController) {
        
        super.init()
        
        merge(with: eventController)
        
    }
    
    static func == (lhs: EventController, rhs: EventController) -> Bool {
        
        var lhsId: String? = nil
        var rhsId: String? = nil
        
        var errorLog: String = "Event Error log: \n"
        
        do { try lhsId = lhs.getId() } catch let error as EventError { errorLog.append("lhs id: " + error.rawValue + "\n") } catch { errorLog.append("lhs id: " + error.localizedDescription + "\n") }
        do { try rhsId = rhs.getId() } catch let error as EventError { errorLog.append("rhs id: " + error.rawValue + "\n") } catch { errorLog.append("rhs id: " + error.localizedDescription + "\n") }
        
        print(errorLog)
        
        if lhsId == nil || rhsId == nil { return false }
        
        return lhsId == rhsId
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
    
        if let other = object as? EventController {
         
            var id: String? = nil
            var otherId: String? = nil
            
            var errorLog: String = "Event Error log: \n"
            
            do { try id = self.getId() } catch let error as EventError { errorLog.append("self id: " + error.rawValue + "\n") } catch { errorLog.append("self id: " + error.localizedDescription + "\n") }
            do { try otherId = other.getId() } catch let error as EventError { errorLog.append("other id: " + error.rawValue + "\n") } catch { errorLog.append("other id: " + error.localizedDescription + "\n") }
            
            print(errorLog)
            
            if id == nil || otherId == nil { return false }
            
            return id == otherId
            
        } else {
            
            return false
            
        }
        
    }
    
    func merge(with eventController: EventController) {
        
        var errorLog: String = "Event error log: \n"
        
        do { try setId(id: try eventController.getId()) } catch let error as EventError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { try setTitle(title: try eventController.getTitle()) } catch let error as EventError { errorLog.append("title: " + error.rawValue + "\n") } catch { errorLog.append("title: " + error.localizedDescription + "\n") }
        do { try setDetails(details: try eventController.getDetails()) } catch let error as EventError { errorLog.append("details: " + error.rawValue + "\n") } catch { errorLog.append("details: " + error.localizedDescription + "\n") }
        do { try setOnlineURL(onlineURL: try eventController.getOnlineURL().absoluteString) } catch let error as EventError { errorLog.append("onlineURL: " + error.rawValue + "\n") } catch { errorLog.append("onlineURL: " + error.localizedDescription + "\n") }
        do { try setStartDate(startDate: try eventController.getStartDate()) } catch let error as EventError { errorLog.append("startDate: " + error.rawValue + "\n") } catch { errorLog.append("startDate: " + error.localizedDescription + "\n") }
        do { try setEndDate(endDate: try eventController.getEndDate()) } catch let error as EventError { errorLog.append("endDate: " + error.rawValue + "\n") } catch { errorLog.append("endDate: " + error.localizedDescription + "\n") }
        do { try setLocation(location: try eventController.getLocation()) } catch let error as EventError { errorLog.append("location: " + error.rawValue + "\n") } catch { errorLog.append("location: " + error.localizedDescription + "\n") }
        do { try setAuthorId(authorId: try eventController.getAuthorId()) } catch let error as EventError { errorLog.append("authorId: " + error.rawValue + "\n") } catch { errorLog.append("authorId: " + error.localizedDescription + "\n") }
        do { try setCategory(category: try eventController.getCategory()) } catch let error as EventError { errorLog.append("category: " + error.rawValue + "\n") } catch { errorLog.append("category: " + error.localizedDescription + "\n") }
        do { try setAttendeesIds(attendeesIds: eventController.getAttendeesIds()) } catch let error as EventError { errorLog.append("attendeesIds: " + error.rawValue + "\n") } catch { errorLog.append("attendeesIds: " + error.localizedDescription + "\n") }
        do { try setPublic(isPublic: eventController.isPublic()) } catch let error as EventError { errorLog.append("isPublic: " + error.rawValue + "\n") } catch { errorLog.append("isPublic: " + error.localizedDescription + "\n") }
        do { try setPoppin(isPoppin: eventController.isPoppin()) } catch let error as EventError { errorLog.append("isPoppin: " + error.rawValue + "\n") } catch { errorLog.append("isPoppin: " + error.localizedDescription + "\n") }
        do { try setEditable(isEditable: eventController.isEditable()) } catch let error as EventError { errorLog.append("isEditable: " + error.rawValue + "\n") } catch { errorLog.append("isEditable: " + error.localizedDescription + "\n") }
        
        if errorLog == "Event error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func merge(with eventModel: EventModel) {
        
        var errorLog: String = "Event error log: \n"
        
        do { if let id = eventModel.id { try setId(id: id) } } catch let error as EventError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { if let title = eventModel.title { try setTitle(title: title) } } catch let error as EventError { errorLog.append("title: " + error.rawValue + "\n") } catch { errorLog.append("title: " + error.localizedDescription + "\n") }
        do { if let details = eventModel.details { try setDetails(details: details) } } catch let error as EventError { errorLog.append("details: " + error.rawValue + "\n") } catch { errorLog.append("details: " + error.localizedDescription + "\n") }
        do { if let onlineURL = eventModel.onlineURL { try setOnlineURL(onlineURL: onlineURL.absoluteString) } } catch let error as EventError { errorLog.append("onlineURL: " + error.rawValue + "\n") } catch { errorLog.append("onlineURL: " + error.localizedDescription + "\n") }
        do { if let startDate = eventModel.startDate { try setStartDate(startDate: startDate) } } catch let error as EventError { errorLog.append("startDate: " + error.rawValue + "\n") } catch { errorLog.append("startDate: " + error.localizedDescription + "\n") }
        do { if let endDate = eventModel.endDate { try setEndDate(endDate: endDate) } } catch let error as EventError { errorLog.append("endDate: " + error.rawValue + "\n") } catch { errorLog.append("endDate: " + error.localizedDescription + "\n") }
        do { if let location = eventModel.location { try setLocation(location: location) } } catch let error as EventError { errorLog.append("location: " + error.rawValue + "\n") } catch { errorLog.append("location: " + error.localizedDescription + "\n") }
        do { if let authorId = eventModel.authorId { try setAuthorId(authorId: authorId) } } catch let error as EventError { errorLog.append("authorId: " + error.rawValue + "\n") } catch { errorLog.append("authorId: " + error.localizedDescription + "\n") }
        do { if let category = eventModel.category { try setCategory(category: category) } } catch let error as EventError { errorLog.append("category: " + error.rawValue + "\n") } catch { errorLog.append("category: " + error.localizedDescription + "\n") }
        do { try setAttendeesIds(attendeesIds: eventModel.attendeesIds) } catch let error as EventError { errorLog.append("attendeesIds: " + error.rawValue + "\n") } catch { errorLog.append("attendeesIds: " + error.localizedDescription + "\n") }
        do { try setPublic(isPublic: eventModel.isPublic) } catch let error as EventError { errorLog.append("isPublic: " + error.rawValue + "\n") } catch { errorLog.append("isPublic: " + error.localizedDescription + "\n") }
        do { try setPoppin(isPoppin: eventModel.isPoppin) } catch let error as EventError { errorLog.append("isPoppin: " + error.rawValue + "\n") } catch { errorLog.append("isPoppin: " + error.localizedDescription + "\n") }
        do { try setEditable(isEditable: eventModel.isEditable) } catch let error as EventError { errorLog.append("isEditable: " + error.rawValue + "\n") } catch { errorLog.append("isEditable: " + error.localizedDescription + "\n") }
        
        if errorLog == "Event error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func setId(id: String) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        if id.isEmpty { throw EventError.invalidParameter }
            
        if event.id != nil { throw EventError.attributeHasBeenSet }
        
        event.id = id
        
    }
    
    func setTitle(title: String) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        if title.isEmpty || title.count > 50 || title.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw EventError.invalidParameter }
        
        event.title = title
        
    }
    
    func setDetails(details: String) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        if details.isEmpty || details.count > 500 || details.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw EventError.invalidParameter }
        
        event.details = details
        
    }
    
    func setOnlineURL(onlineURL: String) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        if let onlineURL = URL(string: onlineURL) {
            
            event.onlineURL = onlineURL
            
        } else {
            
            throw EventError.invalidParameter
            
        }
        
    }
    
    func setStartDate(startDate: Date) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        guard let now = Clock.now else { throw EventError.onlineClockNotAvailable }
        
        if now.isAfterDate(startDate, granularity: .minute) { throw EventError.invalidParameter }
        
        if (now + 15.minutes) > startDate { throw EventError.invalidParameter }
        
        if (now + 7.days) < startDate { throw EventError.invalidParameter }
        
        event.startDate = startDate
        
    }
    
    func setEndDate(endDate: Date) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        guard let startDate = event.startDate else { throw EventError.attributeHasNotBeenSet }
        
        if startDate.isAfterDate(endDate, granularity: .minute) { throw EventError.invalidParameter }
        
        if (startDate + 30.minutes) > endDate { throw EventError.invalidParameter }
        
        if (startDate + 8.hours) < endDate { throw EventError.invalidParameter }
        
        event.endDate = endDate
        
    }
    
    func setLocation(location: CLLocationCoordinate2D) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        event.location = location
        
    }
    
    func setAuthorId(authorId: String) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        if event.authorId != nil { throw EventError.attributeHasBeenSet }
        
        if authorId.isEmpty { throw EventError.invalidParameter }
        
        event.authorId = authorId
        
    }
    
    func setCategory(category: EventCategory) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        event.category = category
        
    }
    
    func addAttendee(attendeeId: String) throws {
        
        if attendeeId.isEmpty { throw EventError.invalidParameter }
        
        event.attendeesIds.append(attendeeId)
        
    }
    
    func removeAttendee(attendeeId: String) throws {
        
        if attendeeId.isEmpty { throw EventError.invalidParameter }
        
        if event.attendeesIds.isEmpty { throw EventError.unableToRemoveParameter }
        
        if !event.attendeesIds.remove(object: attendeeId) { throw EventError.unableToRemoveParameter }
        
    }
    
    func setAttendeesIds(attendeesIds: [String]) throws {
        
        for attendeeId in attendeesIds { try addAttendee(attendeeId: attendeeId) }
        
    }
    
    func setPublic(isPublic: Bool) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        event.isPublic = isPublic
        
    }
    
    func setPoppin(isPoppin: Bool) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        event.isPoppin = isPoppin
        
    }
    
    func setEditable(isEditable: Bool) throws {
        
        if !event.isEditable { throw EventError.nonEditable }
        
        event.isEditable = isEditable
        
    }
    
    func getId() throws -> String {
        
        guard let id = event.id else { throw EventError.attributeHasNotBeenSet }
        
        return id
        
    }
    
    func getTitle() throws -> String {
        
        guard let title = event.title else { throw EventError.attributeHasNotBeenSet }
        
        return title
        
    }
    
    func getDetails() throws -> String {
        
        guard let details = event.details else { throw EventError.attributeHasNotBeenSet }
        
        return details
        
    }
    
    func getOnlineURL() throws -> URL {
        
        guard let onlineURL = event.onlineURL else { throw EventError.attributeHasNotBeenSet }
        
        return onlineURL
        
    }
    
    func getStartDate() throws -> Date {
        
        guard let startDate = event.startDate else { throw EventError.attributeHasNotBeenSet }
        
        return startDate
        
    }
    
    func getEndDate() throws -> Date {
        
        guard let endDate = event.endDate else { throw EventError.attributeHasNotBeenSet }
        
        return endDate
        
    }
    
    func getLocation() throws -> CLLocationCoordinate2D {
        
        guard let location = event.location else { throw EventError.attributeHasNotBeenSet }
        
        return location
        
    }
    
    func getAuthorId() throws -> String {
        
        guard let authorId = event.authorId else { throw EventError.attributeHasNotBeenSet }
        
        return authorId
        
    }
    
    func getCategory() throws -> EventCategory {
        
        guard let category = event.category else { throw EventError.attributeHasNotBeenSet }
        
        return category
        
    }
    
    func getAttendeesIds() -> [String] {
        
        return event.attendeesIds
        
    }
    
    func isPublic() -> Bool {
        
        return event.isPublic
        
    }
    
    func isPoppin() -> Bool {
        
        return event.isPoppin
        
    }
    
    func isEditable() -> Bool {
        
        return event.isEditable
        
    }
    
    func rawValue() -> EventModel {
        
        return event
        
    }
    
    func removeOnlineURL() {
        
        event.onlineURL = nil
        
    }
    
    func removeDetails() {
        
        event.details = nil
        
    }
    
}
