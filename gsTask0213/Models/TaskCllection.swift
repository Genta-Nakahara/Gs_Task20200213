//
//  TaskCllection.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/13.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import Foundation

protocol TaskCollectionDelegate: class {
    func saved()
    func loaded()
}

class TaskCollection {
    //初回アクセスのタイミングでインスタンスを生成
    static var shared = TaskCollection()
    
    let taskUseCase:TaskUseCase
    
    //外部からの初期化を禁止
    private init(){
        taskUseCase = TaskUseCase()
        load()
    }
    
    //外部からは参照のみ許可 // ここに全ての情報が持っている！！！
    private var tasks: [Task] = []
    
//    // ここにUserDefaults で使うキーを置いておく。打ち間違いを減らすように。
//    // UserDefaults に使うキー
//    let userDefaultsTasksKey = "user_tasks"
    
    //弱参照して循環参照を防ぐ
    weak var delegate: TaskCollectionDelegate? = nil
    
    func createTask() -> Task {
        let id = taskUseCase.createTaskId()
        return Task(id: id)
        
    }
    
    func getTask (at: Int) -> Task{
        return tasks[at]
    }
    
    func taskCount () -> Int{
        return tasks.count
    }
    
    func addTask(_ task: Task) {
        taskUseCase.addTask(task)
        tasks.append(task)
        save()
    }
    
    func editTask(task: Task, index: Int) {
        taskUseCase.editTask(task)
        tasks[index] = task
        save()
    }
    
    func removeTask(index: Int) {
        taskUseCase.removeTask(taskId: getTask(at: index).id)
        tasks.remove(at: index)
        save()
    }
    
    func save() {
        
        tasks = tasks.sorted(by: {$0.updatedAt.dateValue() > $1.updatedAt.dateValue()})
        delegate?.saved()
    }
    
    func load() {
        taskUseCase.fetchTaskDocuments { (fetchTasks) in
            guard let tasks = fetchTasks else {
                self.save()
                return
            }
            self.tasks = tasks.sorted(by: {$0.updatedAt.dateValue() > $1.updatedAt.dateValue()})
            self.delegate?.loaded()
        }
    }
}
