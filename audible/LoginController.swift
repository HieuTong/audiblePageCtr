//
//  ViewController.swift
//  audible
//
//  Created by HieuTong on 1/23/21.
//
import Foundation
import UIKit

protocol LoginControllerDelegate: NSObjectProtocol {
    func finishLoggingIn()
}

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoginControllerDelegate {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
        
    let pages: [Page] = {
        let firstPage = Page(title: "Share a great listen", message: "It's free to send your books to the people to your life. Every recipient's first book is on us", imageName: "page1")
        
        let secondPage = Page(title: "Send from your library", message: "Tap the More menu next to my book. Choose \"Send this book\"", imageName: "page2")
        
        let thirdPage = Page(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this book\"", imageName: "page3")
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.rgb(r: 247, g: 154, b: 27)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 247, g: 154, b: 27), for: .normal)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 247, g: 154, b: 27), for: .normal)
        return button
    }()
    
    @objc func nextPage() {
        // last page
        if pageControl.currentPage == pages.count {
            return
        }
        
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstrainsOffScreen()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    @objc func skipPage() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observerKeyboardNotifications()
        
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        skipButtonTopAnchor = skipButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)[0]
        
        nextButtonTopAnchor = nextButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 60, heightConstant: 40)[0]
        
        pageControlBottomAnchor = pageControl.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[0]
        
        collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerCells()
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipPage), for: .touchUpInside)
    }
    
    fileprivate func observerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        // we are on the last page
        if pageNumber == pages.count {
            moveControlConstrainsOffScreen()
        } else {
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 30
            nextButtonTopAnchor?.constant = 30
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func moveControlConstrainsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.ID)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: LoginCell.ID)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginCell.ID, for: indexPath) as! LoginCell
//            loginCell.loginController = self
            loginCell.delegate = self
            return loginCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.ID, for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func finishLoggingIn() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        guard let mainNavigationController = rootViewController as? MainNavigationController else {
            return
        }
        
        mainNavigationController.viewControllers = [HomeController()]
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
         
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        //scoll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
    }
}




