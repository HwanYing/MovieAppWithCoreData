//
//  MovieListResult.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/6.
//

import Foundation
import CoreData

// MARK: - MovieListResult
struct MovieListResult: Codable {
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalName, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, firstAirDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
  
    func getVideoType() -> VideoType {
        return self.originalName != nil ? .series : .movie
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext, groupType: BelongsToTypeEntity, similarId: String) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map({
            String($0)
        }).joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.similarId = similarId
        entity.addToBelongsToType(groupType)
        return entity
    }
    
    func toMovieObject(groupType: BelongsToTypeObject) -> MovieObject {
        let object = MovieObject()
        object.id = id!
        object.adult = adult ?? false
        object.backdropPath = backdropPath
        object.genreIDs = genreIDS?.map({
            String($0)
        }).joined(separator: ",")
        object.originalLanguage = originalLanguage
        object.originalName = originalName
        object.originalTitle = originalTitle
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath
        object.releaseDate = releaseDate ?? ""
        object.title = title
        object.video = video ?? false
        object.voteAverage = voteAverage ?? 0
        object.voteCount = voteCount
        object.belongsToType.append(groupType)
        return object
    
    }
}

