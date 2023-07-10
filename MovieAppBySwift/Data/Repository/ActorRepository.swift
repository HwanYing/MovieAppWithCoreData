//
//  ActorRepository.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/6/30.
//

import Foundation
import CoreData
import RealmSwift

protocol ActorRepository {
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void)
    func save(list: [ActorInfoResponse])
    func saveDetails(data: ActorDetailsResponse)
    func getDetails(id: Int, completion: @escaping (ActorDetailsResponse?) -> Void)
    func getTotalPageActorList(completiion: @escaping (Int) -> Void)
}

class ActorRepositoryImpl: BaseRepository, ActorRepository {
    
    static let shared: ActorRepository = ActorRepositoryImpl()
    
    private override init() { }
    
    let contentTypeRepo: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    var pageSize: Int = 20

    func save(list: [ActorInfoResponse]) {
        
        let objects = List<ActorObject>()
        
        list.map {
            $0.toActorObject(contentTypeRepo: contentTypeRepo)
        }.forEach {
            objects.append($0)
        }
        try! realmInstance.realm.write {
            realmInstance.realm.add(objects, update: .modified)
        }
       
       
        
//        list.forEach {
//            let _ = $0.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
//        }
//        self.coreData.saveContext()
    }
    
    func saveDetails(data: ActorDetailsResponse) {
        
        let object = data.toActorObject()
        
        try! realmInstance.realm.write({
            realmInstance.realm.add(object, update: .modified)
        })
        
        
//        let _ = data.toActorEntity(context: coreData.context)
//        coreData.saveContext()
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailsResponse?) -> Void) {
    // Fatal error: Unexpectedly found nil while unwrapping an Optional value
        
        if let actorObject = realmInstance.realm.object(ofType: ActorObject.self, forPrimaryKey: id) {
            completion(actorObject.toActorDetailsResponse())
        } else {
            completion(nil)
        }
      
        
//        coreData.context.perform {
//            // main queue
//            let fetchRequest: NSFetchRequest<ActorEntity> = self.getActorDetailsByID(id)
//            if let items = try? self.coreData.context.fetch(fetchRequest),
//               let firstItem = items.first {
//                completion(ActorEntity.toActorDetailsResponse(entity: firstItem))
//            } else {
//                completion(nil)
//            }
//        }
    }
    
    func getTotalPageActorList(completiion: @escaping (Int) -> Void) {
        
        let actorObjects = realmInstance.realm.objects(ActorObject.self)
        completiion(actorObjects.count)
        print("Actor Total Page from Persistence Database>>> \(actorObjects.count)")

//        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
//        do {
//            let items = try coreData.context.fetch(fetchRequest)
//            completiion(items.count)
//            print("Actor Total Page from Persistence Database>>> \(items.count)")
//        } catch {
//            print("\(#function) \(error.localizedDescription)")
//        }
    }
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        // page problem ---
        let items: [ActorInfoResponse] = realmInstance.realm.objects(ActorObject.self)
            .sorted(byKeyPath: "insertedAt", ascending: false)
            .sorted(byKeyPath: "popularity", ascending: false)
            .sorted(byKeyPath: "name", ascending: true)
            .map {
                $0.toActorInfoResponse()
            }
        completion(items)
        
//        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
//        fetchRequest.sortDescriptors = [
//        NSSortDescriptor(key: "insertedAt", ascending: false),
//        NSSortDescriptor(key: "popularity", ascending: false),
//        NSSortDescriptor(key: "name", ascending: true),
//        ]
//
//        fetchRequest.fetchLimit = pageSize
//        fetchRequest.fetchOffset = (pageSize * page) - pageSize
//
//        do {
//            let items = try coreData.context.fetch(fetchRequest)
//            completion(items.map({ ActorEntity.toActorInfoResponse(entity: $0)
//            }))
//        } catch {
//            print("\(#function) \(error.localizedDescription)")
//            completion([ActorInfoResponse]())
//        }
    }
    
    private func getActorDetailsByID(_ id: Int) -> NSFetchRequest<ActorEntity> {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        return fetchRequest
    }
}
