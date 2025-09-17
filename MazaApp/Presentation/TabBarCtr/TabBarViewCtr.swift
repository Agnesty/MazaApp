//
//  TabBarViewController.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit

class TabBarViewCtr: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewCtr()
        let vc2 = TrendingViewCtr()
        let vc3 = LiveViewCtr()
        let vc4 = PokemonViewCtr()
        let vc5 = ProfileViewCtr()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        vc5.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        
        nav1.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "homeIconBottomBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "homeIconBottomBar")?.withRenderingMode(.alwaysOriginal)
        )

        nav2.tabBarItem = UITabBarItem(
            title: "Trending",
            image: UIImage(named: "trendingIconBottomBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "trendingIconBottomBar")?.withRenderingMode(.alwaysOriginal)
        )

        nav3.tabBarItem = UITabBarItem(
            title: "Live",
            image: UIImage(named: "liveIconBottomBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "liveIconBottomBar")?.withRenderingMode(.alwaysOriginal)
        )

        nav4.tabBarItem = UITabBarItem(
            title: "Pokemon",
            image: UIImage(named: "pokemonIconBottomBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "pokemonIconBottomBar")?.withRenderingMode(.alwaysOriginal)
        )

        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "profilIconBottomBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "profilIconBottomBar")?.withRenderingMode(.alwaysOriginal)
        )

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        nav5.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
    }

}
