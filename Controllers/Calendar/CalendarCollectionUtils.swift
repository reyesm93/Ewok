//
//  CalendarCollectionUtils.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/26/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//
import UIKit

extension CalendarVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendarData.monthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let month = calendarData.monthArray[section][0]
        var sectionLength = month.length + month.firstWeekDay - 1
        
        if sectionLength > 28 {
            if sectionLength > 35 {
                sectionLength = 42
            } else {
                sectionLength = 35
            }
        } else {
            sectionLength = 28
        }
        return sectionLength
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.backgroundColor=UIColor.clear
        
        let month = calendarData.monthArray[indexPath.section][0]
        if (indexPath.item < month.firstWeekDay - 1) || (indexPath.item > (month.firstWeekDay + month.length - 2)) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            let day = indexPath.item - month.firstWeekDay + 2
            cell.lbl.text="\(day)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if startFilter != nil {
            if endFilter != nil {
                highlightArray.removeAll()
                startFilter = indexPath
                highlightArray.append(startFilter!)
                endFilter = nil
            } else {
                if indexPath.item <= startFilter!.item {
                    highlightArray.removeAll()
                    startFilter = indexPath
                    highlightArray.append(startFilter!)
                } else {
                    endFilter = indexPath
                    
                    let from = (startFilter?.item)!
                    let to = (endFilter?.item)!
                    
                    for index in from...to {
                        highlightArray.append(IndexPath(index: index))
                    }
                    
                }
            }
        } else {
            startFilter = indexPath
        }
        
        print("item: \(indexPath.item)")
        print("row: \(indexPath.row)")
        print("section: \(indexPath.section)")
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let monthHeader = calendarView.myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeader
//
//        return monthHeader
//
//    }

}
