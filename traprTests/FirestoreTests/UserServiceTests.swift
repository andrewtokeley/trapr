//
//  UserServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 28/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class UserServiceTests: XCTestCase {

    let userService = ServiceFactory.sharedInstance.userService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        
        // Delete all user records before each test
        // TODO
    }

    func testRegisterUser() {
        let expect = expectation(description: "testRegisteredUser")
        
        let authUser = AuthenticatedUser(email: "andrewtokeley@gmail.com")
        userService.registerAuthenticatedUser(authenticatedUser: authUser) { (user, error) in
        
            XCTAssertNotNil(user)
            
            // by default the user should only be given the "contributor" role, not admin or editor
            XCTAssertTrue(user?.isInRole(role: .contributor) ?? false)
            XCTAssertFalse(user?.isInRole(role: .admin) ?? true)
            XCTAssertFalse(user?.isInRole(role: .editor) ?? true)
            
            XCTAssertNil(error)
            
            self.userService.delete(user: user!, completion: { (error) in
                XCTAssertNil(error)
                expect.fulfill()
            })
            
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }

    func testUpdatingLastOpenedApp() {
        let expect = expectation(description: "testUpdatingLastOpenedApp")

        // create a new user
        let authUser = AuthenticatedUser(email: "andrewtokeley@gmail.com")
        userService.registerAuthenticatedUser(authenticatedUser: authUser) { (user, error) in
            
            if let user = user {
                let date = Date().add(1, 1, -1)
                self.userService.updateLastOpenedApp(user: user, lastOpenedApp: date, completion: { (error) in
                    XCTAssertNil(error)
                    
                    self.userService.delete(user: user, completion: { (error) in
                        XCTAssertNil(error)
                        
                        expect.fulfill()
                    })
                })
                
                
            } else {
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 200) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }

}
