//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Виктория Демченко on 01.04.24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
