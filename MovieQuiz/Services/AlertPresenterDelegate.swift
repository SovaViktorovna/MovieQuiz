//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Виктория Демченко on 01.04.24.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didReceiveAlert(alert: UIAlertController)
}
