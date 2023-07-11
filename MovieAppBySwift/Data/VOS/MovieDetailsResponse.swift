//
//  MovieDetailsResponse.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/7.
//

import Foundation
import CoreData
import RealmSwift

// MARK: - MovieDetailsResponse
public struct MovieDetailsResponse: Codable {
    public let adult: Bool?
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int?
    public let genres: [MovieGenre]?
    public let homepage: String?
    public let id: Int?
    public let imdbID, originalLanguage, originalTitle, overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let releaseDate: String?
    public let firstAirDate: String?
    public let revenue, runtime: Int?
    public let spokenLanguages: [SpokenLanguage]?
    public let status, tagline, title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genres?.map({
            String($0.id)
        }).joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalTitle
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.productionCountries?.addingObjects(from: productionCountries!)
        entity.productionCompany?.addingObjects(from: productionCompanies!)
        entity.spokenLanguage?.addingObjects(from: spokenLanguages!)
        entity.genres?.addingObjects(from: genres!)
        return entity
    }
    
    func toMovieObject() -> MovieObject {
        let object = MovieObject()
        // Fatal error: Unexpectedly found nil while unwrapping an Optional value
        object.id = id!
        object.adult = adult ?? false
        object.backdropPath = backdropPath
        object.genreIDs = genres?.map({
            String($0.id)
        }).joined(separator: ",")
        object.originalLanguage = originalLanguage
        object.originalName = originalTitle
        object.originalTitle = originalTitle
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath
        object.releaseDate = releaseDate ?? ""
        object.productionCompany.append(objectsIn: productionCompanies!.compactMap({
            $0.toProductionCompanyObject()
        }))
        object.productionCountries.append(objectsIn: productionCountries!.compactMap({
            $0.toProductionCountryObject()
        }))
        object.spokenLanguage.append(objectsIn: spokenLanguages!.compactMap({
            $0.toSpokenLanguageObject()
        }))
        object.belongsToCollection = belongsToCollection?.toBelongsToCollectionObject()
        object.genres.append(objectsIn: genres!.compactMap({
            $0.toGenreObject()
        }))
        object.title = title
        object.video = video ?? false
        object.voteAverage = voteAverage ?? 0
        object.voteCount = voteCount
        return object
    }
}

// MARK: - BelongsToCollection
public struct BelongsToCollection: Codable {
    public let id: Int?
    public let name, posterPath, backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    func toBelongsToCollectionObject() -> BelongsToCollectionObject {
        let object = BelongsToCollectionObject()
        object.id = id!
        object.name = name
        object.posterPath = posterPath
        object.backdropPath = backdropPath
        return object
    }
    
    @discardableResult
    func toBelongsToCollectionEntity() -> BelongsToCollectionEntity {
        let entity = BelongsToCollectionEntity()
        entity.id = Int32(id!)
        entity.name = name
        entity.posterPath = posterPath
        entity.backdropPath = backdropPath
        return entity
    }
}

// MARK: - ProductionCompany
public struct ProductionCompany: Codable, Hashable {
   public let id: Int?
   public let logoPath: String?
   public let name, originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    func toProductionCompanyObject() -> ProductionCompanyObject {
        let object = ProductionCompanyObject()
        object.id = id!
        object.name = name
        object.originalCountry = originCountry
        object.logoPath = logoPath
        return object
    }
    
    @discardableResult
    func toProductionCompanyEntity() -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity()
        entity.id = Int32(id!)
        entity.name = name
        entity.originalCountry = originCountry
        entity.logoPath = logoPath
        return entity
    }
}

// MARK: - ProductionCountry
public struct ProductionCountry: Codable, Hashable {
    public let iso3166_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    func toProductionCountryObject() -> ProductionCountryObject {
        let object = ProductionCountryObject()
        object.name = name
        object.iso3166_1 = iso3166_1
        return object
    }
    
    @discardableResult
    func toProductionCountryEntity() -> ProductionCountryEntity {
        let entity = ProductionCountryEntity()
        entity.name = name
        entity.iso3166_1 = iso3166_1
        return entity
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable, Hashable {
    public let englishName, iso639_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    func toSpokenLanguageObject() -> SpokenLanguageObject {
        let object = SpokenLanguageObject()
        object.englishName = englishName
        object.iso639_1 = iso639_1
        object.name = name
        return object
    }
    
    @discardableResult
    func toSpokenLanguageEntity() -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity()
        entity.englishName = englishName
        entity.iso639_1 = iso639_1
        entity.name = name
        return entity
    }
}
