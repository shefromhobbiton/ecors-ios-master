//
//  ViewController.swift
//  eCoRs
//
//  Created by She Razon-Bulalaque on 29/07/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit
import MSAL

class MainViewController: UIViewController {
    
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    //MSAL connection vars
    let kEndpoint = "https://ecorsapp.b2clogin.com/tfp/%@/%@"
    let kTenantName = "ecorsapp.onmicrosoft.com" // Your tenant name
    let kClientID = "7564993d-daad-47c0-8a03-30a54c47c97a" // Your client ID from the portal when you created your application
    let policySignIn = "B2C_1_ECORS_2";
    let policySignUp = "B2C_1_ECORS_3";
    let kGraphURI = "https://ecorsapp.b2clogin.com/ecorsapp.onmicrosoft.com/oauth2/v2.0/token?p=" // This is your backend API that you've configured to accept your app's tokens
    let kScopes: [String] = ["https://ecorsapp.onmicrosoft.com/mywebclient/user_impersonation"] // This is a scope that you've configured your backend API to look for
    var token = ""
    
    //utils
    let utils = Utils()
    let dataController = DataController()
    let questionList = QuestionListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    /**************************************
     *   Button Sign In Event Handler
     ***************************************/
    @IBAction func btnSignInClickEvent(_ sender: UIButton) {
        
        //request Azure connection
        requestAzureADBConnection()
    }
    
    /**************************************
     *   Button Register Event HandleR
     ***************************************/
    @IBAction func btnRegisterClickEvent(_ sender: Any) {
        
    }
    
    /*************************************  CONNECTIVITY FUNCTIONS - START  *************************************/
    //connect to azure AD B2C
    //return TRUE when successful
    func requestAzureADBConnection() {
        
        let kAuthority = String(format: kEndpoint, kTenantName, policySignIn)
        
        do {
            guard let authorityURL = URL(string: kAuthority) else {
                return
            }
            
            let redirectUri = "msal" + kClientID + "://auth"
            
            let authority = try MSALB2CAuthority.init(url: authorityURL)
            let config = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: redirectUri, authority: authority)
            config.knownAuthorities = [authority]
            
            let application = try MSALPublicClientApplication.init(configuration: config)
            
            /**
             Acquire a token for a new user using interactive authentication
             - forScopes: Permissions you want included in the access token received in the result in the completionBlock. Not all scopes are gauranteed to be included in the access token returned.
             - completionBlock: The completion block that will be called when the authentication flow completes, or encounters an error.
             */
            
            //DispatchQueue.main.async {
                
                let tp = MSALInteractiveTokenParameters(scopes: self.kScopes)
                application.acquireToken(with: tp) { (result, error) in
                    
                    if  error == nil {
                        let accessToken = (result?.accessToken)!
                        self.token = accessToken
                        
                        //TEMP
                        print("token >>>>>>>")
                        print(accessToken)
                        
                        //check which action
                        switch _requestType {
                        case "GET":
                            self.getWorkflow()
                            break
                        case "POST":
                            self.sendWorkflowResponse()
                            break
                        default:
                            break
                        }
                        
                        
                    } else {
                        //show alert
                        self.utils.showOKAlert(title: "eCors Error", message: "Could not acquire token")
                        
                    }
                }
            //}
            //return connected
        } catch {
            //show alert
            self.utils.showOKAlert(title: "eCors Error", message: "Unable to create application")
        }
        
        
    }
    
    //api requests
    func getWorkflow() {
        
        print(">>>>>>> GET WORKFLOW <<<<<<<<<")
        //set activity indicator
        self.setActivityIndicator()
        self.showActivityIndicator(show: true)
        
        let endPoint = "https://driverapp.azurewebsites.net/api/workflow"
        
        //create URL from string endPoint
        guard let endPointURL = URL(string: endPoint) else {
            print("Error creating URL.")
            return
        }
        
        var urlRequest = URLRequest(url:endPointURL)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer " + self.token, forHTTPHeaderField:"Authorization")  //header
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            //TEMP
            if error != nil {
                print("Error = \(String(describing: error))")
            }
            
            DispatchQueue.main.async {
                
                guard let data = data else {return}
                print("DATA -> ", data)
                //parse JSON data
                let dataController = DataController()
                dataController.parseJSONData(JSONData: data)
                
                switch _isInitialLoad {
                    
                case true:
                    //show question list screen
                    self.showQuestionListScreen()
                    _isInitialLoad = false
                    break
                case false:
                    //clear tableview
                    self.questionList.clearTableViewCells()
                    
                    //reload table view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.questionList.reloadTableView()
                    }
                    break
                }
            }
        })
        
        task.resume()
    }
    
    //send workflow response
    func sendWorkflowResponse() {
        
        print(">>>>>>>> SEND RESPONSE <<<<<<<<<<<")
        print(self.token)
        
        //set url endpoint
        let endPoint = "https://driverapp.azurewebsites.net/api/workflow"
        
        //create URL from string endPoint
        guard let endPointURL = URL(string: endPoint) else {
            print("Error creating URL.")
            return
        }
        
        var urlRequest = URLRequest(url:endPointURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")  //header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData =  try JSONSerialization.data(withJSONObject: _workflowAnswers, options: JSONSerialization.WritingOptions())
            urlRequest.httpBody = jsonData
            
        } catch {
            print("Error creating JSON data")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?)->Void in
            
            DispatchQueue.main.async {
                
                //let statusCode = (response as? HTTPURLResponse)?.statusCode
                let responseCode = ((response as? HTTPURLResponse)?.statusCode)!
                print("STATUS CODE -> ", responseCode as Any)
                
                //process server response
                self.processServerReponse(responseCode: responseCode)
                
            }
            return
        })
        task.resume()
        
    }
    
    //process server response after sending
    func processServerReponse(responseCode: Int) {
        
        let mainController = MainViewController()
        
        if responseCode == 401 {
            _requestType = "POST"
            //request new connection
            mainController.requestAzureADBConnection()
        } else if responseCode == 200 {
            //check if last workflow
            if _isLastWorkflow == false {
                
                //request next workflow
                mainController.getWorkflow()
                
            } else {
                //return to main screen
                if let view = self.view {
                    view.removeFromSuperview()
                }
            }
        } else {
            
            //return to Main Screen
            utils.showOKAlert(title: "eCoRs", message: "Unable to connect to server. Please try again later.")
        }
    }
    //*************************************  CONNECTIVITY FUNCTIONS - END *************************************/
    
    //show Question List Screen
    func showQuestionListScreen() {
        
        //temp -- show questionnaire screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionListViewController")
        self.present(newViewController, animated: true, completion: { self.showActivityIndicator(show: false)} )
    }
    
    
    /************************************************************
     *Helper function to control activityIndicator's animation
     ************************************************************/
    fileprivate func showActivityIndicator(show: Bool) {
        if show {
            print("show indicator")
            activityIndicator.startAnimating()
        } else {
            print("hide indicator")
            activityIndicator.stopAnimating()
            activityIndicatorContainer.removeFromSuperview()
        }
    }
    
    /***********************************************
     *draw activity indicator
     ***********************************************/
    fileprivate func setActivityIndicator() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // Configure the background containerView for the indicator
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = screenWidth * 0.5    //webView.center.x
        // Need to subtract 44 because WebKitView is pinned to SafeArea
        //   and we add the toolbar of height 44 programatically
        activityIndicatorContainer.center.y = screenHeight * 0.5 //webView.center.y
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.8
        activityIndicatorContainer.layer.cornerRadius = 10
        
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.addSubview(activityIndicator)
        self.view.addSubview(activityIndicatorContainer)
        
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
}

