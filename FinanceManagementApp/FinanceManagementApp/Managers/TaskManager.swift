//
//  TaskManager.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/23.
//

import Foundation

struct ServerResponse: Codable {
    let message: String
    let tasks: [Task]
}

struct DeleteResponse: Codable {
    let message: String
    let tasks: [Task]
}

func sendDataToPHP(taskName: String, dueDate: String, status: String,completion:@escaping ((Result<[Task],Error>) -> Void)) {
    // 送信先のURL
    guard let url = URL(string: "http://localhost:8000/receiveData.php") else {
        print("URLが無効です")
        return
    }

    // 送信するデータ
    let dataToSend: [String: Any] = [
        "task_name": taskName,
        "due_date": dueDate,
        "status": status
    ]

    // リクエストの作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // JSONにエンコード
        let jsonData = try JSONSerialization.data(withJSONObject: dataToSend, options: [])
        request.httpBody = jsonData
    } catch {
        print("JSONエンコードエラー: \(error.localizedDescription)")
        return
    }

    // URLSessionでリクエストを送信
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("エラー: \(error.localizedDescription)")
            completion(.failure(error))
//            return
        }

        // レスポンスの処理
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTPステータスコード: \(httpResponse.statusCode)")
        }

        if let data = data {
            do {
                // レスポンスをJSONとして解析
                let decodedResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                completion(.success(decodedResponse.tasks))
                
            } catch {
                print("JSONデコードエラー: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

func deleteDataToPHP(from task: Task, completion:@escaping ((Result<[Task],Error>) -> Void)) {
    // 送信先のURL
    guard let url = URL(string: "http://localhost:8000/deleteData.php") else {
        print("URLが無効です")
        return
    }

    // 送信するデータ
    let dataToSend: [String: Any] = [
        "task_name": task.taskName,
        "due_date": task.dueDate,
        "status": task.status
    ]

    // リクエストの作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // JSONにエンコード
        let jsonData = try JSONSerialization.data(withJSONObject: dataToSend, options: [])
        request.httpBody = jsonData
    } catch {
        print("JSONエンコードエラー: \(error.localizedDescription)")
        return
    }

    // URLSessionでリクエストを送信
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("エラー: \(error.localizedDescription)")
            completion(.failure(error))
//            return
        }

        // レスポンスの処理
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTPステータスコード: \(httpResponse.statusCode)")
        }

        if let data = data {
            do {
                // レスポンスをJSONとして解析
                let decodedResponse = try JSONDecoder().decode(DeleteResponse.self, from: data)
                
                
                completion(.success(decodedResponse.tasks))
                
            } catch {
                print("JSONデコードエラー: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

func updateDataToPHP(from task: Task, completion:@escaping ((Result<[Task],Error>) -> Void)) {
    // 送信先のURL
    guard let url = URL(string: "http://localhost:8000/updateTaskStatus.php") else {
        print("URLが無効です")
        return
    }

    // 送信するデータ
    let dataToSend: [String: Any] = [
        "task_name": task.taskName,
        "due_date": task.dueDate,
        "status": task.status
    ]

    // リクエストの作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // JSONにエンコード
        let jsonData = try JSONSerialization.data(withJSONObject: dataToSend, options: [])
        request.httpBody = jsonData
    } catch {
        print("JSONエンコードエラー: \(error.localizedDescription)")
        return
    }

    // URLSessionでリクエストを送信
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("エラー: \(error.localizedDescription)")
            completion(.failure(error))
        }

        // レスポンスの処理
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTPステータスコード: \(httpResponse.statusCode)")
        }

        if let data = data {
            do {
                // レスポンスをJSONとして解析
                let decodedResponse = try JSONDecoder().decode(DeleteResponse.self, from: data)
                
                completion(.success(decodedResponse.tasks))
                
            } catch {
                print("JSONデコードエラー: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

struct Animal {
    var name:String
    var age:Int
}

struct Task: Codable,Identifiable {
    let id: Int
    let taskName: String
    let dueDate: String
    let status: String

    // JSONのキー名とSwiftのプロパティ名を一致させるためのカスタムマッピング
    enum CodingKeys: String, CodingKey {
        case id
        case taskName = "task_name"
        case dueDate = "due_date"
        case status
    }
}

import Foundation

func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
    guard let url = URL(string: "http://localhost:8000/getTasks.php") else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error)) // ネットワークエラー
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }

        do {
            let tasks = try JSONDecoder().decode([Task].self, from: data)
            completion(.success(tasks)) // デコード成功
        } catch {
            completion(.failure(error)) // デコードエラー
        }
    }
    task.resume()
}

