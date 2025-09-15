//
//  BannerSwitch.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 05/09/25.
//

import Foundation

struct HomeResponse: Decodable {
    let banners: [Banners]
    let detailUserCards: [DetailUserCardItem]
    let sellingServices: [SellingServiceItem]
    let tabsHomeMenu: [TabsHomeMenu]
}

struct Banners: Decodable {
    let id: Int
    let imageUrl: String
}

struct DetailUserCardItem: Decodable {
    let id: Int
    let iconName: String
    let text: String
    let bgColorHex: String
}

struct SellingServiceItem: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
}

struct TabsHomeMenu: Decodable {
    let id: Int
    let tabName: String
}
