//
//  NotificationService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation
import UserNotifications
import RxSwift

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestAuthorization() -> Observable<Bool> {
        return Observable.create { observer in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(granted)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func scheduleNotification(title: String, body: String, after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
