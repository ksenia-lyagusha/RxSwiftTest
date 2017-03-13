//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by CHI Software on 13.03.17.
//  Copyright © 2017 CHI Software. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxSwiftExt

enum Like {
    case like, dislike
}

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var thumbUpImageView: UIImageView!
    @IBOutlet weak var thumbDownImageView: UIImageView!
    
    let disposeBag = DisposeBag()
//    let httpClient = HTTPClient()
    var thumb = Like.like
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textFieldAction()
        buttonAction()
    }

    private func textFieldAction() {
        textField.rx.text
            .orEmpty                                            //textField.rx.text sends <String?> events. Here I ignore any nil to have only <String> events
            .distinctUntilChanged()                             //When textField starts or ends beeing first responder it sends current text as <String> event. DistinctUntilChanged will propagete only those string which are diffrent than previous one.
            .debounce(0.3, scheduler: MainScheduler.instance)   //Here we wait 0.3 seconds to be sure that user doesn't want to tap multiple times
            .subscribe(onNext: {[weak self] text in
                self?.search(withQuery: text)
            }).addDisposableTo(disposeBag)
    }
    
    private func buttonAction() {
        
        button.rx.tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.like()
            }).addDisposableTo(disposeBag)
    }
    
    
    private func search(withQuery query: String) {
        print("[\(Date())]: ### Searching with query: \(query)")
    }
    
    private func like() {
        thumb = thumb == .dislike ? .like : .dislike
        
        switch thumb {
        case .like:
            thumbUpImageView.isHidden = thumbUpImageView.isHidden ? false : true
        case .dislike:
            thumbDownImageView.isHidden = thumbDownImageView.isHidden ? false : true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

