import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    var currentQuestion: QuizQuestion?
    private var presenter: MovieQuizPresenter!
    private var statisticService = StatisticServiceImplementation()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
    }
    
    
    
    func didReceiveAlert(alert: UIAlertController){
        self.present(alert, animated: true, completion: nil)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderWidth = 0
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let message = """
        Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
        Количество сыграных квизов: \(statisticService.gameCount)
         "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%
        """
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAnswerOrResult(isCorrect: Bool){
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        self.presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            
        }
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                style: .default) { [weak self] _ in
            
            self?.presenter.restartGame()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
