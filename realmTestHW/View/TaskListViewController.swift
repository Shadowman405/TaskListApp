//
//  TaskListViewController.swift
//  realmTestHW
//
//  Created by Maxim Mitin on 21.08.21.
//

import UIKit
import  RealmSwift

class TaskListViewController: UITableViewController {
    
    private var taskList: Results<TaskList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTempData()
        taskList = StorageManager.shared.realm.objects(TaskList.self)

        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = taskList[indexPath.row]
        cell.configure(with: taskList)

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let taskList = taskList[indexPath.row]
        
        guard let tasksVC = segue.destination as? TasksViewController else {return}
        tasksVC.taskList = taskList
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        showAlert()
    }
    
// MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = taskList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(tasklist: currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(tasklist: currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
// Default entities
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
    
//MARK: -
    
    @IBAction func sortingSegmentControl(_ sender: UISegmentedControl) {
        
        taskList = sender.selectedSegmentIndex == 0 ? taskList.sorted(byKeyPath: "name") : taskList.sorted(byKeyPath: "date")
        tableView.reloadData()
    }
    
}


extension TaskListViewController {
    
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil ){
        
        let title = taskList != nil ? "Edit List" : "New List"
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Input")
        
        alert.action(with: taskList) { newValue in
            if let tasklist = taskList, let completion = completion {
                StorageManager.shared.edit(tasklist: tasklist, newValue: newValue)
                completion()
            } else {
                self.save(tasklist: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(tasklist: String) {
        let tasklist = TaskList(value: [tasklist])
        
        StorageManager.shared.save(taskList: tasklist)
        let rowIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
