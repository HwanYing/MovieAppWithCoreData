//
//  ActorActionDelegate.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/4/5.
//

import Foundation

protocol ActorActionDelegate { //: class
    
    func onTapFavourite(isFavourite: Bool)
    
    func onTapActorImage(actorId: Int)
        
//    func onTapItem(data: ActorInfoResponse)

}
