//
//  MainController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/7/22.
//

import Foundation
import UIKit
import Firebase
import UserNotifications
import FirebaseAuth

private let reuseIdentifier = "VictoryCell"
private let headerIdentifier = "MainHeaderView"
class MainController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var currentUser: User?
    var victories = [Victory]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var count: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    var goalCount: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var dayBeforeCount: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    var yesterdaysCount: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    var requestUser: User? {
        didSet {
            setupPushNotifications()
        }
    }
    let waitListView = WaitListView()
    var lastVictory : Victory?
    var refreshControl = UIRefreshControl()
    var endReached : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        configureUI()
        setupObserver()
     
        VictoryService.shared.getYesterdayCount { count in
            self.yesterdaysCount = count
            print("This is last 24hours count: \(count)")
        }
        
        VictoryService.shared.getDayBeforeCount { count in
            self.dayBeforeCount = count
            print("This is the day before count: \(count)")
        }
        
        let currentUserUid = UserDefaults.standard.value(forKey: "currentUserUid") as? String



    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func checkIfUserRespected(victories: [Victory], lastIndex: Int) {
        for var (index, value) in victories.enumerated() {
            VictoryService.shared.checkIfUserRespected(victoryId: value.victoryID) { bool in
                print("Index: \(lastIndex + index + 1) Respect: \(bool) Value: \(self.firstTenCharacters(value: value.victoryText))")
                let fixedIndex = lastIndex + index + 1
                if lastIndex == 0 {
                    self.victories[index].didRespect = bool
                } else {
                    self.victories[fixedIndex].didRespect = bool
                }
                
           
                self.collectionView.reloadData()
            }
        }
       
    }
    
    func firstTenCharacters(value: String) -> String {
        let stringArray = value.components(separatedBy: "")
        var newString = ""
        for (index, char) in stringArray.enumerated() {
            if index < 10 {
                newString.append(char)
            }
        }
        
        return newString
        
    }
 
    
    func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadVictories), for: .valueChanged)
        collectionView.backgroundColor = .white
        configureNavigationBar(title: "User", prefersLargeTitles: false)
        collectionView.register(VictoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureNavigationBar(title: "Victory HQ", prefersLargeTitles: false)
        setupRightBarButtonItem()
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        overrideUserInterfaceStyle = .light
        

        
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVictories), name: NSNotification.Name.init(rawValue: "fetchVictories"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearInfo), name: NSNotification.Name.init(rawValue: "logout"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad), name: NSNotification.Name.init(rawValue: "login"), object: nil)
        
        
    }
    
    @objc func clearInfo() {
        self.currentUser = nil
        self.waitListView.removeFromSuperview()
        
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in. Present login screen here.")
            presentLoginScreen()
        } else {
            fetchCurrentUser()
            print("DEBUG: User is logged in. Configure controller...")
        }
    }
    
   @objc func reloadVictories() {
       self.victories.removeAll()
       self.yesterdaysCount = nil
       self.dayBeforeCount = nil
       self.lastVictory = nil
       self.collectionView.reloadData()
       endReached = false
       VictoryService.shared.getDayBeforeCount { count in
           self.dayBeforeCount = count
       }

       VictoryService.shared.getYesterdayCount {
           count in
           self.yesterdaysCount = count
       }
       fetchVictories()
    }

    
    @objc func fetchCurrentUser() {
        UserService.shared.fetchCurrentUser { user in
            self.currentUser = user
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "fetchUserInformation"), object: nil)
            if user == nil {
                self.showWaitListView()
                self.setupPushNotifications()
            } else {
                self.fetchVictories()
                self.fetchTotalVictories()
                guard let user = user else {
                    return
                }
                self.setCurrentUser(user: user)
            }
           
        }
    }
    
    func presentCelebrateController(number: Int) {
        let controller = CelebrateController()
        controller.int = number
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func fetchTotalVictories() {
        let userDefaults = UserDefaults.standard
        VictoryService.shared.fetchTotalVictoryCount { int in
            self.count = int
            switch int {
            case 0...49:
                self.goalCount = 100
            case 50...99:
                self.goalCount = 100
                if userDefaults.bool(forKey: "Victory50") == false {
                    self.presentCelebrateController(number: 50)
                    userDefaults.set(true, forKey: "Victory50")
                }
            case 100...249:
                self.goalCount = 250
                if userDefaults.bool(forKey: "Victory100") == false {
                    self.presentCelebrateController(number: 100)
                    userDefaults.set(true, forKey: "Victory100")
                }
            case 250...499:
                self.goalCount = 500
                if userDefaults.bool(forKey: "Victory250") == false {
                    self.presentCelebrateController(number: 250)
                    userDefaults.set(true, forKey: "Victory250")
                }
            case 500...749:
                self.goalCount = 750
                if userDefaults.bool(forKey: "Victory500") == false {
                    self.presentCelebrateController(number: 500)
                    userDefaults.set(true, forKey: "Victory500")
                }
            case 750...999:
                self.goalCount = 1000
                if userDefaults.bool(forKey: "Victory750") == false {
                    self.presentCelebrateController(number: 750)
                    userDefaults.set(true, forKey: "Victory750")
                }
            case 1000...1499:
                self.goalCount = 1500
                if userDefaults.bool(forKey: "Victory1000") == false {
                    self.presentCelebrateController(number: 1000)
                    userDefaults.set(true, forKey: "Victory1000")
                }
            default: break
            }
        }
    }
    

    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
        
    func setCurrentUser(user: User) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.uid, forKey: "currentUserUid")
        setupPushNotifications()
        
        if user.uid == "anXVskxWosOsZBLfPJ3ODeKRmFw2" {
            userDefaults.set(true, forKey: "admin")
        }
    }
    
    func setUser() {
        let userDefaults = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userDefaults.set(uid, forKey: "currentUserUid")
        setupPushNotifications()
        
        if uid == "anXVskxWosOsZBLfPJ3ODeKRmFw2" {
            userDefaults.set(true, forKey: "admin")
        }
    }
    
    func setupRightBarButtonItem() {
        let button = UIButton()
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        let rightButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    
    func showWaitListView() {
        self.view.addSubview(waitListView)
        waitListView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
    
    @objc func plusButtonTapped() {
        guard let currentUser = currentUser else {
            return
        }
        let controller = NewVictoryController()
        controller.currentUser = currentUser
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func fetchVictories() {
        VictoryService.shared.fetch20Victories(lastVictory: lastVictory) { victories in
            let lastIndex : Int?
            if self.lastVictory == nil {
                print("last index is nil")
                lastIndex = 0
            }  else {
                lastIndex = self.victories.count - 1
            }
            if victories.count == 0 {
                self.endReached = true
            }
            
            
            
            self.victories.append(contentsOf: victories)
            self.lastVictory = victories.last
            guard let lastIndex = lastIndex else {
                return
            }
            self.checkIfUserRespected(victories: victories, lastIndex: lastIndex)
            self.collectionView.refreshControl?.endRefreshing()
            
            self.collectionView.reloadData()
          
            print("This is the victories loaded: \(victories.count)")
        }
        
    }
    
    func setupPushNotifications() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let pushManager = PushNotificationManager(userID: currentUser.uid)
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "PushNotifications") == false {
            pushManager.registerForPushNotifications()
            self.registerForPushNotifications()
            
            userDefaults.set(true, forKey: "PushNotifications")
        } else {
            print("Already asked to receive push notifications")
        }
        
        pushManager.updateFirestorePushTokenIfNeeded()
        

   
    }
    
    func setupPushManager() {
        guard let currentUser = currentUser else {
            return
        }
        let pushManager = PushNotificationManager(userID: currentUser.uid)
        
        pushManager.updateFirestorePushTokenIfNeeded()
    }
    
    func registerForPushNotifications() {
      //1
            UNUserNotificationCenter.current()
              //2
              .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    
                }
                //3
                print("Permission granted: \(granted)")
              }
    }
    

    
    func presentDeleteAlert(victory: Victory, row: Int) {
        
        let alert = UIAlertController(title: "Delete Victory", message: "Are you sure you want to delete this Victory?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { _ in
            VictoryService.shared.deleteVictory(victory: victory) {
                print("Successfully deleted Victory")
                self.victories.remove(at: row)
                self.collectionView.reloadData()
            }
        }
        let action2 = UIAlertAction(title: "Nope", style: .cancel) { _ in
        }
        alert.addAction(action)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return victories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VictoryCell
        cell.victory = victories[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure()
       
        return cell
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! MainHeaderView
        header.backgroundColor = .red
        header.count = count
            header.goalCount = goalCount
            header.dayBeforeCount = dayBeforeCount
            header.yesterdayCount = yesterdaysCount
            return header
        }
        return UICollectionReusableView()
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.victories.count - 1 {
            if endReached == false {
                fetchVictories()
                
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension MainController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        print("AuthenticationComplete function firing")
//        self.fetchCurrentUser()
     
    }
}

extension MainController: VictoryCellDelegate {
    func unrespectTapped(cell: VictoryCell) {
        guard let currentUser = currentUser, let victory = cell.victory else { return }
        self.victories[cell.tag].didRespect?.toggle()
        VictoryService.shared.unrespectVictory(victory: victory, user: currentUser, completion: {
            self.collectionView.reloadData()
        })
    }
    
    func respectTapped(cell: VictoryCell) {
        guard let currentUser = currentUser, let victory = cell.victory else { return }
        print("passed respectTapped guard statement")
        self.victories[cell.tag].didRespect?.toggle()
        VictoryService.shared.respectVictory(victory: victory, user: currentUser, completion: {
            self.collectionView.reloadData()
        })
        
        let body = "\(currentUser.fullName) respected your victory."
        guard let token = cell.token else { return }
        print("We got the cell token")
        PushNotificationSender.shared.sendPushNotification(to: token, title: "New Respect", body: body, id: currentUser.uid)
    }
    
    func detailsTapped(cell: VictoryCell) {
        guard let victory = cell.victory else { return }
        if let details = victory.victoryDetails, !details.isEmpty {
            let controller = VictoryDetailsController()
            if let userImage = cell.profileImageView.image {
                controller.userImage = userImage
            }
            controller.victory = victory
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func moreButtonTapped(cell: VictoryCell) {
    }
    
    func longPress(cell: VictoryCell) {
        guard let victory = cell.victory, let uid = Auth.auth().currentUser?.uid else { return }
        if victory.uid == uid {
            self.presentDeleteAlert(victory: victory, row: cell.tag)
        }
    }
    
    func profilePicTapped(cell: VictoryCell) {
        guard let victory = cell.victory else { return }
        let controller = ViewProfileController()
        controller.uid = victory.uid
        controller.titleString = victory.fullName
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
}



