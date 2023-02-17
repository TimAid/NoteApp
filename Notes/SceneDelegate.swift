//
//  SceneDelegate.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
  
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
         
        let noteDataSource = NoteDataSource()
        
        let navigationVC = UINavigationController(rootViewController: ViewController(noteDataSource: noteDataSource))
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }



}

