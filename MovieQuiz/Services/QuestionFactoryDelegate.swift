//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Виктория Демченко on 29.03.24.
//

import Foundation

protocol  QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
