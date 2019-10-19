//
//  testeFilmrUITests.swift
//  testeFilmrUITests
//
//  Created by Gabriel Sousa on 15/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import XCTest

class testeFilmrUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        
        app = XCUIApplication()
            app.terminate()
            continueAfterFailure = false
            app.launch()
        
       
    }

    override func tearDown() {
         app.terminate()
        
    }

    func testarCollectionView() {
                                                
        let verticalScrollBar3PagesCollectionView = XCUIApplication()/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 3 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 3 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        verticalScrollBar3PagesCollectionView.swipeUp()
        verticalScrollBar3PagesCollectionView.swipeUp()
        verticalScrollBar3PagesCollectionView.swipeUp()
        verticalScrollBar3PagesCollectionView.swipeDown()
        verticalScrollBar3PagesCollectionView.swipeDown()
        verticalScrollBar3PagesCollectionView.swipeDown()
        verticalScrollBar3PagesCollectionView.swipeDown()
                 
    }
    
    func testarVideo() {
        
        
        let app = XCUIApplication()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"video 1").element.tap()
        
        let nextButton = app.buttons["next"]
        nextButton.tap()
        nextButton.tap()
        
        let backvideoButton = app.buttons["backVideo"]
        backvideoButton.tap()
        backvideoButton.tap()
        app.buttons["pause"].tap()
        app.buttons["play"].tap()
        XCUIDevice.shared.orientation = .landscapeRight
        
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0)
        let element = element2.children(matching: .other).element
        element.tap()
        
        let nextButton2 = element2.buttons["next"]
        nextButton2.tap()
        nextButton2.tap()
        
        let backvideoButton2 = element2.buttons["backVideo"]
        backvideoButton2.tap()
        backvideoButton2.tap()
        element2.buttons["pause"].tap()
        element.tap()
                  
        
    }
    
}
