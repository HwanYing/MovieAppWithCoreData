//
//  ActorListResult.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/7.
//

import Foundation
import CoreData

// MARK: - ActorListResult
struct ActorListResult: Codable {
    let page: Int?
    let results: [ActorInfoResponse]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ActorInfoResponse: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownFor: [KnownFor]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
    @discardableResult
    func toActorEntity(context: NSManagedObjectContext, contentTypeRepo: ContentTypeRepository) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.gender = Int32(gender ?? 0)
        entity.knownForDepartment = knownForDepartment
        entity.alsoKnownAs = knownFor?.map({
            $0.originalName ?? "unknown"
        }).joined(separator: ",")
        entity.name = name
        entity.popularity = popularity ?? 0.0
        entity.profilePath = profilePath
        return entity
    }
    
    
    func toActorObject(contentTypeRepo: ContentTypeRepository) -> ActorObject  {
        let object = ActorObject()
        object.id = Int(id!)
        object.name = name
        object.profilePath = profilePath
        object.adult = adult
        object.gender = gender
        object.popularity = popularity
        object.knownForDepartment = knownForDepartment
        
        return object
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let mediaType: MediaType?
    let originalLanguage: String?
    let originalTitle, overview, posterPath, releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let firstAirDate, name: String?
    let originCountry: [String]?
    let originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum KnownForDepartment: String, Codable {
    case acting = "Acting"
    case directing = "Directing"
}
