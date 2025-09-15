//
//  PexelsVideoRespons.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation

struct PexelsVideoResponse: Codable {
    let videos: [PexelsVideo]
}

struct PexelsVideo: Codable {
    let id: Int
    let url: String
    let user: PexelsUser
    let video_files: [PexelsVideoFile]
}

struct PexelsUser: Codable {
    let name: String
}

struct PexelsVideoFile: Codable {
    let link: String
    let quality: String
    let file_type: String
}
