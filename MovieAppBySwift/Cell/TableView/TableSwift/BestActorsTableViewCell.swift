//
//  BestActorsTableViewCell.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/4/5.
//

import UIKit

class BestActorsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var moreActorsLabel: UILabel!
    @IBOutlet weak var bestActorCollectionView: UICollectionView!
    @IBOutlet weak var heightForActorCollectionView: NSLayoutConstraint!
       
    var onTapViewMore: (([ActorInfoResponse])->Void) = { _ in  }
    var onClickActorView: ((Int) -> Void) = { _ in }
//    var delegate : ActorActionDelegate? = nil
    
    var data: [ActorInfoResponse]? {
        didSet {
            if let _ = data {
                bestActorCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        moreActorsLabel.underLineText(text: "MORE ACTORS")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMoreLabel))
        moreActorsLabel.isUserInteractionEnabled = true
        moreActorsLabel.addGestureRecognizer(tapGesture)
        
        setUpCollectionViewCells()
    }
  
    @objc func didTapMoreLabel() {
        onTapViewMore(data!)
    }
   
    private func setUpCollectionViewCells() {
        bestActorCollectionView.dataSource = self
        bestActorCollectionView.delegate = self
        bestActorCollectionView.registerCollectionCell(identifier: BestActorsCollectionViewCell.identifier)
        
//        let itemWidth: CGFloat = bestActorCollectionView.frame.width
        let itemWidth: CGFloat = 130
        let itemHeight: CGFloat = itemWidth * 1.5
        heightForActorCollectionView.constant = itemHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func onTapFavourite(isFavourite: Bool) {
        debugPrint("IsFavourite ====> \(isFavourite)")
    }

}
extension BestActorsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestActorsCollectionViewCell.identifier, for: indexPath) as? BestActorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.mainActorData = data?[indexPath.row]
        return cell
    }
}

extension BestActorsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 130
        let itemHeight: CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        onClickActorView(item?.id ?? 0)
    }
}
