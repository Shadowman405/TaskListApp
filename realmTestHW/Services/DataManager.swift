//
//  DataManager.swift
//  realmTestHW
//
//  Created by Maxim Mitin on 24.08.21.
//

import Foundation


class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(_ completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            UserDefaults.standard.set(true, forKey: "done")
            
            let shopingList = TaskList()
            shopingList.name = "Shopping list 2.0"
            
            let movieList = TaskList(value: ["SeriesList", Date(),[["GoT"], ["Last dance","Better call Soul", Date(), true]]])
            
            let milk = Task()
            milk.name = "Milk"
            milk.note = "2L"
            
            let bread = Task(value: ["Chicken", "", Date(), true])
            let apples = Task(value: ["name": "Pineapples", "note": "4Kg"])
            
            shopingList.tasks.append(milk)
            shopingList.tasks.insert(contentsOf: [bread , apples], at: 0)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(taskList: [shopingList, movieList])
                completion()
            }
            
        }
    }
}
