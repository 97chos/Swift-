//
//  MovieVO.swift
//  MyMovieChart
//
//  Created by 조상호 on 2020/10/20.
//  Copyright © 2020 조상호. All rights reserved.
//

import Foundation
import UIKit

class MovieVO {
    var thumbnail: String? //영화 섬네일 이미지 주소
    var title: String? // 영화 제목
    var description: String? // 영화 설명
    var detail: String? // 상세 정보
    var opendate: String? // 개봉일
    var rating: Double? // 평점
    
    var thumbnailImage: UIImage?
}
