//
//  MovieRepository.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/30.
//

import Foundation
import CoreData
import RealmSwift

protocol MovieRepository {
    func getDetail(id: Int, completion: @escaping (MovieDetailsResponse?) -> Void)
    func getMovieResult(id: Int, completion: @escaping (MovieResult?) -> Void)
    func saveDetail(data: MovieDetailsResponse)
    func saveList(type: MovieSerieGroupType, data: MovieListResult)
    func saveSimilarContent(id: Int, data: [MovieResult])
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void)
    func saveCasts(id: Int, data: [MovieCast])
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
   
    static let shared: MovieRepository = MovieRepositoryImpl()
    
    private override init() { }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    private var contentTypeMapO = [String: BelongsToTypeObject]()
    
    let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func getDetail(id: Int, completion: @escaping (MovieDetailsResponse?) -> Void) {
        // background queue to
        
        if let movieObject = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id) {
            completion(movieObject.toMovieDetailResponse())
        } else {
            completion(nil)
        }
     
//        coreData.context.perform {
//            // main queue
//            let fetchRequest : NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
//
//            if let items = try? self.coreData.context.fetch(fetchRequest),
//               let firstItem = items.first {
//                completion(MovieEntity.toMovieDetailResponse(entity: firstItem))
//            } else {
//                completion(nil)
//            }
//        }
        
    }
    func getMovieResult(id: Int, completion: @escaping (MovieResult?) -> Void) {
        
        if let object = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id){
            completion(object.toMovieResult())
        } else {
            completion(nil)
        }
        
    }
    
    
    func saveDetail(data: MovieDetailsResponse) {
        
        let object = data.toMovieObject()
        
        try! realmInstance.realm.write({
            realmInstance.realm.add(object, update: .modified)
        })
        
        //        coreData.context.perform {
        //            // main queue
        //            let _ = data.toMovieEntity(context: self.coreData.context)
        //            self.coreData.saveContext()
        //        }
    }
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        
        if let movieObject = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id) {
            try! realmInstance.realm.write({
                let newMovieObject = realmInstance.realm.create(MovieObject.self, value: movieObject, update: .modified)
                newMovieObject.similarMovies.append(objectsIn: data.map {
                    
                    realmInstance.realm.create(MovieObject.self,
                                               value: $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: .similarMovies)),
                                               update: .modified)
                }
                )
                
                
                realmInstance.realm.add(newMovieObject, update: .modified)
            })
        }
        //        coreData.context.perform {
        //            data.forEach {
        //                $0.toMovieEntity(context: self.coreData.context, groupType: self.contentTypeRepo.getBelongsToTypeEntity(type: .similarMovies), similarId: String(id))
        //            }
        //            self.coreData.saveContext()
        //        }
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        
        if let movieObject = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id) {
            completion(movieObject.similarMovies.map({
                $0.toMovieResult()
            }))
        } else {
            completion([MovieResult]())
        }
        //        coreData.context.perform {
        //            let fetchRequest: NSFetchRequest<MovieEntity> = self.getSimilarMoviesByID(id)
        //            let items = try? self.coreData.context.fetch(fetchRequest)
        //            items?.forEach({ entity in
        //                var movieLists : [MovieResult] = []
        //                movieLists.append(MovieEntity.toMovieResult(entity: entity))
        //                completion(movieLists)
        //            })
        //        }
    }
    
    func saveCasts(id: Int, data: [MovieCast]) {
        
        if let movieObject = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id) {
            
            try! realmInstance.realm.write({
                let newMovieObject = realmInstance.realm.create(MovieObject.self, value: movieObject, update: .modified)
                newMovieObject.casts.append(objectsIn: data.map {
                    $0.convertToActorInfoResponse()
                }.map { (source) -> ActorObject in
                    let actorObject = source.toActorObject(contentTypeRepo: contentTypeRepo)
                    let newActorObject = realmInstance.realm.create(ActorObject.self,value: actorObject, update: .modified)
                    return newActorObject
                }
                                            
                )
                
                realmInstance.realm.add(newMovieObject)
            })
        }
        //        coreData.context.perform {
        //            data.forEach {
        //                $0.toActorEntity(context: self.coreData.context, movieId: id)
        //            }
        //            self.coreData.saveContext()
        //        }
        
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        
        if let movieObject = realmInstance.realm.object(ofType: MovieObject.self, forPrimaryKey: id) {
            completion(movieObject.casts.map { $0.toMovieCast() })
        } else {
            completion([MovieCast]())
        }
        
        //        coreData.context.perform {
        //            let fetchRequest: NSFetchRequest<ActorEntity> = self.getMovieCastsFetchRequestByID(id)
        //            let items = try? self.coreData.context.fetch(fetchRequest)
        //            items?.forEach({ entity in
        //                var movieCasts : [MovieCast] = []
        //                movieCasts.append(ActorEntity.toMovieCast(entity: entity))
        //                completion(movieCasts)
        //            })
        //        }
    }
    
    func saveList(type: MovieSerieGroupType, data: MovieListResult) {
        
        let movieObjects = List<MovieObject>()

        data.results!.compactMap({
            $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: type))
        }).forEach {
            movieObjects.append($0)
        }
        
        try! realmInstance.realm.write {
            print("Movie List Result>>>>>>>>>", movieObjects.count)
            realmInstance.realm.add(movieObjects, update: .modified)
        }
      
//        coreData.context.perform {
//            data.results?.forEach({
//                $0.toMovieEntity(
//                    context: self.coreData.context,
//                    groupType: self.contentTypeRepo.getBelongsToTypeEntity(type: type), similarId: ""
//                )
//            })
//            self.coreData.saveContext()
//        }
    }
    
    private func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity> {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
    private func getMovieCastsFetchRequestByID(_ movieId: Int) -> NSFetchRequest<ActorEntity> {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "movieID", "\(movieId)")
        return fetchRequest
    }
    
    private func getSimilarMoviesByID(_ id: Int) -> NSFetchRequest<MovieEntity> {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "similarId", "\(id)")
        return fetchRequest
    }
}
