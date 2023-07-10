//
//  ContentTypeRepository.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/30.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name: String) -> BelongsToTypeEntity
    func save(name: String) -> BelongsToTypeObject
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity
    func getBelongsToTypeObject(type: MovieSerieGroupType) -> BelongsToTypeObject
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
   
    static let shared: ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    private var contentTypeMapO = [String: BelongsToTypeObject]()
    
    private override init() {
        super.init()
        
        initializeData()
    }
    
    private func initializeData() {
        /// Process Existing Data
        
        let dataSource = realmInstance.realm.objects(BelongsToTypeObject.self)
        
        if dataSource.isEmpty {
            /// Insert initial data
            MovieSerieGroupType.allCases.forEach {
                let _ : BelongsToTypeObject = save(name: $0.rawValue)
            }
        } else {
            dataSource.forEach {
                contentTypeMapO[$0.name] = $0
            }
        }
        
        ///
//        let fetchRequest: NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
//        do {
//            let dataSource = try self.coreData.context.fetch(fetchRequest)
//
//            if dataSource.isEmpty {
//                /// Insert initial data
//                MovieSerieGroupType.allCases.forEach {
//                    save(name: $0.rawValue)
//                }
//            } else {
//                /// Map existing data
//                dataSource.forEach {
//                    if let key = $0.name {
//                        contentTypeMap[key] = $0
//                    }
//                }
//            }
//        } catch {
//            print(error)
//        }
    }
    @discardableResult
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        
        contentTypeMap[name] = entity
        
        coreData.saveContext()
        return entity
    }
    
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
        if let object = contentTypeMapO[type.rawValue] {
            let items = object.movies.sorted { (first, second) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "")!
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "")!
                
                return firstDate.compare(secondDate) == .orderedDescending
            }.map {
                $0.toMovieResult()
            }
            completion(items)
        } else {
            completion([MovieResult]())
        }
        
//        if let entity = contentTypeMap[type.rawValue],
//           let movies = entity.movies,
//           let itemSet = movies as? Set<MovieEntity> {
//            completion(Array(itemSet.sorted(by: { (first, second) -> Bool in
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
//                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
//
//                return firstDate.compare(secondDate) == .orderedDescending
//            })).map { MovieEntity.toMovieResult(entity: $0) })
//        } else {
//            completion([MovieResult]())
//        }
    }
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
    
    @discardableResult
    func save(name: String) -> BelongsToTypeObject {
        let object = BelongsToTypeObject()
        object.name = name
        
        contentTypeMapO[name] = object
        
        try! realmInstance.realm.write({
            realmInstance.realm.add(object, update: .modified)
        })
        return object
    }
    
    func getBelongsToTypeObject(type: MovieSerieGroupType) -> BelongsToTypeObject {
        if let object = contentTypeMapO[type.rawValue] {
            return object
        }
        return save(name: type.rawValue)
    }
    
    
}
