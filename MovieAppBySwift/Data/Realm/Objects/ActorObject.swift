//
//  ActorObject.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/7/7.
//

import Foundation
import RealmSwift

class ActorObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var adult: Bool?
    
    @Persisted
    var alsoKnownAs: String?
    
    @Persisted
    var biography: String?
    
    @Persisted
    var birthday: String?
    
    @Persisted
    var deathday: String?
    
    @Persisted
    var gender: Int?
    
    @Persisted
    var homePage: String
    
    @Persisted
    var imdbID: String?
    
    @Persisted
    var insertedAt: Date?
    
    @Persisted
    var knownForDepartment: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var placeOfBirth: String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var profilePath: String?
    
    func toActorDetailsResponse() -> ActorDetailsResponse {
        return ActorDetailsResponse(
            adult: adult,
            alsoKnownAs: alsoKnownAs?.components(separatedBy: ","),
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: gender,
            homepage: homePage,
            id: id,
            imdbID: imdbID,
            knownForDepartment: knownForDepartment,
            name: name,
            placeOfBirth: placeOfBirth,
            popularity: popularity,
            profilePath: profilePath)
    }
    
    func toActorInfoResponse() -> ActorInfoResponse {
        return ActorInfoResponse(
            adult: adult,
            gender: gender,
            id: id,
            knownFor: [KnownFor(adult: adult, backdropPath: "", genreIDS: [], id: id, mediaType: .movie, originalLanguage: "", originalTitle: "", overview: "", posterPath: "", releaseDate: "", title: "", video: false, voteAverage: 0.0, voteCount: 0, firstAirDate: "", name: name, originCountry: [], originalName: "")],
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath)
    }
    
    
    func toMovieCast() -> MovieCast {
        return MovieCast(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: alsoKnownAs,
            popularity: popularity,
            profilePath: profilePath,
            castID: id,
            character: "",
            creditID: "",
            order: 0,
            department: knownForDepartment,
            job: "")
    }
   
}
