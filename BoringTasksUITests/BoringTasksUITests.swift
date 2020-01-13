//
//  BoringTasksUITests.swift
//  BoringTasksUITests
//
//  Created by Murat Corlu on 11/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import XCTest

var currentLanguage: (langCode: String, localeCode: String)? {
    let currentLocale = Locale(identifier: Locale.preferredLanguages.first!)
    guard let langCode = currentLocale.languageCode else {
        return nil
    }
    var localeCode = langCode
    if let scriptCode = currentLocale.scriptCode {
        localeCode = "\(langCode)-\(scriptCode)"
    } else if let regionCode = currentLocale.regionCode {
        localeCode = "\(langCode)-\(regionCode)"
    }
    return (langCode, localeCode)
}

func localizedString(_ key: String) -> String {
    let testBundle = Bundle(for: BoringTasksUITests.self)
    if let currentLanguage = currentLanguage,
        let testBundlePath = testBundle.path(forResource: currentLanguage.localeCode, ofType: "lproj") ?? testBundle.path(forResource: currentLanguage.langCode, ofType: "lproj"),
        let localizedBundle = Bundle(path: testBundlePath)
    {
        return NSLocalizedString(key, bundle: localizedBundle, comment: "")
    }
    return "?"
}

class BoringTasksUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // UI tests must launch the application that they test.
        // Use recording to get started writing UI tests.
    //        let strAddTask = localizedString("ADD_TASK")
    //        let strTaskDone = localizedString("ACTION_DONE")
    //        let strTaskSkip = localizedString("ACTION_SKIP")
        let strAddList = localizedString("ADD_LIST")
        let strDone = localizedString("DONE")
//        let strCancel = localizedString("CANCEL")
        let strListTitle = localizedString("TASK_LIST_TITLE")

        let app = XCUIApplication()
        let tablesQuery = app.tables
//        let elementsQuery = app.scrollViews.otherElements

        app.buttons[strAddList].tap()
        tablesQuery.textFields[strListTitle].tap()
                
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
//        tKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
//        eKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
//        sKey.tap()
        
        let tKey2 = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey2.tap()
//        tKey2.tap()
        app.navigationBars[strAddList].buttons[strDone].tap()
        snapshot("01List")
//        tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["Test"].tap()
//
//        app.buttons["İş Ekle"].tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Başlık"]/*[[".cells.textFields[\"Başlık\"]",".textFields[\"Başlık\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        tKey.tap()
//        tKey.tap()
//        eKey.tap()
//        sKey.tap()
//        sKey.tap()
//        tKey2.tap()
//        tKey2.tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Count"]/*[[".cells.textFields[\"Count\"]",".textFields[\"Count\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let silKey = app/*@START_MENU_TOKEN@*/.keys["Sil"]/*[[".keyboards.keys[\"Sil\"]",".keys[\"Sil\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        silKey.tap()
//        silKey.tap()
//
//        let key = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//        key.tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Period"]/*[[".cells.buttons[\"Period\"]",".buttons[\"Period\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.buttons["haftada"]/*[[".cells.buttons[\"haftada\"]",".buttons[\"haftada\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        snapshot("01AddItem")
//        app.navigationBars["İş Ekle"].buttons["Tamam"].tap()
//
//        testStaticText/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        elementsQuery.buttons["Yaptım"].tap()
//        snapshot("01ItemList")
//        testStaticText/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        snapshot("02ItemAction")
//        elementsQuery.buttons["Ertele"].tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
