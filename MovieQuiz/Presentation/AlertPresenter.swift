//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Виктория Демченко on 01.04.24.
//

import UIKit

class AlertPresenter {
    static func show(alert data: AlertModel, controller delegate: AlertPresenterDelegate){
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction (
            title: data.buttonText,
            style: .default) { _ in
                data.completion()
            }
        alert.addAction(action)
        delegate.didReceiveAlert(alert: alert)
    }
}
