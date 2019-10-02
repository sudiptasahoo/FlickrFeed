//
//  MockModel.swift
//  NetworkingTests
//
//  Created by Sudipta Sahoo on 19/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

struct FakeContact: Codable{

    var id: Int
    var firstName: String?
    var lastName: String?
    var profilePic: String?
    var favorite: Bool
    var url: String?
    var email: String?
    var phoneNumber: String?
    
    init() {
        id = -1
        firstName = nil
        lastName = nil
        profilePic = nil
        favorite = false
        url = nil
        email = nil
        phoneNumber = nil
    }
}

class MockContact {
    
    static let shared = MockContact()
    
    var contact: FakeContact {
        
        var contact = FakeContact()
        contact.id = 10
        contact.firstName = "Ricky"
        contact.lastName = "Martin"
        contact.profilePic = "/sample.png"
        contact.favorite = false
        contact.url = "https://api.example.com/path/person/10"
        contact.email = "ricky.martin@email.com"
        contact.phoneNumber = "+1909090909090"
        return contact
    }
    
    
    lazy var contacts: [FakeContact] = {
        
        var contact1 = FakeContact()
        contact1.id = 11
        contact1.firstName = "Wibin"
        contact1.lastName = "Ayinikat"
        contact1.profilePic = "/mock.png"
        contact1.favorite = true
        contact1.url = "https://api.example.com/path/value"
        contact1.email = "example@test.com"
        contact1.phoneNumber = "9000090000"
        
        var contact2 = FakeContact()
        contact2.id = 12
        contact2.firstName = ")Wibin"
        contact2.lastName = "Ayinikat"
        contact2.profilePic = "/mock.png"
        contact2.favorite = true
        contact2.url = "https://api.example.com/path/value"
        contact2.email = "example@test.com"
        contact2.phoneNumber = "9000090000"
        
        var contact3 = FakeContact()
        contact3.id = 12
        contact3.firstName = "1Wibin"
        contact3.lastName = "Ayinikat"
        contact3.profilePic = "/mock.png"
        contact3.favorite = true
        contact3.url = "https://api.example.com/path/value"
        contact3.email = "example@test.com"
        contact3.phoneNumber = "9000090000"
        
        return [self.contact, contact1, contact2, contact3]
    }()
    
    var contactJson: String {
        return """
        {"email":"ricky.martin@email.com","id":-1,"last_name":"Martin","favorite":false,"phone_number":"+1909090909090","first_name":"Ricky"}
        """
    }
    
    var contactData: Data? {
        return contactJson.data(using: .utf8)
    }
}
