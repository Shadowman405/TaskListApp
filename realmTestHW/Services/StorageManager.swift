//
//  StorageManager.swift
//  realmTestHW
//
//  Created by Maxim Mitin on 21.08.21.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - Work with Tasklist
    func save(taskList: [TaskList]) {
        write {
            realm.add(taskList)
        }
    }
    
    func save(taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func delete(tasklist: TaskList) {
        write {
            realm.delete(tasklist.tasks)
            realm.delete(tasklist)
        }
    }
    
    func edit(tasklist: TaskList, newValue: String){
        write {
            tasklist.name = newValue
        }
    }
    
    func done(tasklist: TaskList) {
        write {
            tasklist.tasks.setValue(true, forKey: "isComplete")
        }
    }
    //MARK: - Work with task
    func save(task: Task, tasklist: TaskList){
        write {
            tasklist.tasks.append(task)
        }
    }
    
    func edit(task: Task, name: String, note: String) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func delete(task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func done(task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    
    //MARK: - Handler and unwrap for Realm
    private func write(_ completion: () -> Void) {
        do {
            try realm.write{
                completion()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
