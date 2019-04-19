//
//  ViewController.swift
//  RxErrors
//
//  Created by Juanjo Ramos Rodriguez on 27/03/2019.
//  Copyright © 2019 Juanjo Ramos Rodriguez. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt

enum ApplicationErrors: Error {
    case apiError
}

class ViewController: UIViewController {

    @IBOutlet var valueButton: UIButton!
    @IBOutlet var errorButton: UIButton!
    @IBOutlet var outputLabel: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
//        configureViewWithoutErrors()
    }
    
    private func configureView() {
        let tapObservable = valueButton.rx
            .tap
            .map { true }
        
        let errorObservable = errorButton.rx
            .tap
            .map { false }
        
        let buttonsObservable = Observable.merge(tapObservable, errorObservable)
            .flatMap { [unowned self] shouldSucceed in
                return self.fetchDataFromServer(shouldSucceed: shouldSucceed)
            }.scan(0) { accumulator, _  in
                return accumulator + 1
            }.map { "\($0)" }
        
        buttonsObservable.bind(to: outputLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureViewWithoutErrors() {
        let tapObservable = valueButton.rx
            .tap
            .map { true }
        
        let errorObservable = errorButton.rx
            .tap
            .map { false }
        
        let buttonsObservable = Observable.merge(tapObservable, errorObservable)
            .flatMap { [unowned self] shouldSucceed in
                return self.fetchDataFromServer(shouldSucceed: shouldSucceed)
                    .materialize()
            }.elements()
            .scan(0) { accumulator, _  in
                return accumulator + 1
            }.map { "\($0)" }
        
        buttonsObservable.bind(to: outputLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func fetchDataFromServer(shouldSucceed: Bool) -> Observable<Bool> {
        return shouldSucceed ? Observable.just(true) : Observable.error(ApplicationErrors.apiError)
    }

}

