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

        let month = calendarData.monthArray[section]
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
        
        let month = calendarData.monthArray[indexPath.section]
        if (indexPath.item < month.firstWeekDay - 1) || (indexPath.item > (month.firstWeekDay + month.length - 2)) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            let day = indexPath.item - month.firstWeekDay + 2
            cell.lbl.text="\(day)"
            
            let firstTran = limitsIndexPath![0]
            let lastTran = limitsIndexPath![1]
            let isBefore = indexPath < firstTran
            let isAfter = indexPath > lastTran
            
            if indexPath == todayIndexPath {
                cell.lbl.font = cell.lbl.font.bold
            }
            
            if isBefore || isAfter {
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = .gray
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if startFilter != nil {
            if endFilter != nil {
                restartRange(collectionView, indexPath)
                endFilter = nil
            } else {
                if indexPath < startFilter! {
                    restartRange(collectionView, indexPath)
                } else if indexPath > startFilter! {
                    selectedDateRange.removeAll()
                    endFilter = indexPath
                    setDateRange(collectionView)
                }
            }
        } else {
            startFilter = indexPath
            selectedDateRange.append(startFilter!)
        }
        
        for cell in selectedDateRange {
            highlightCell(collectionView, cell)
        }
        
        print("item: \(indexPath.item)")
        print("section: \(indexPath.section)")
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let monthHeader = calendarView.myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeader
        let month = calendarData.monthArray[indexPath.section]
        
        monthHeader.monthLbl.text = "   " + month.name

        return monthHeader

    }
    
    fileprivate func highlightCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if cell.isHidden == false {
            cell.backgroundColor = .black
            cell.lbl.textColor = .white
        }
    }
    
    fileprivate func unHighlightCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if cell.isHidden == false {
            cell.backgroundColor = .clear
            cell.lbl.textColor = .black
        }
    }
    
    fileprivate func restartRange(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        for cell in selectedDateRange {
            unHighlightCell(collectionView, cell)
        }
        
        selectedDateRange.removeAll()
        startFilter = indexPath
        selectedDateRange.append(startFilter!)
    }
    
    fileprivate func setDateRange(_ collectionView: UICollectionView) {
        let from = IndexPath(item: (startFilter?.item)!, section: (startFilter?.section)!)
        let to = IndexPath(item: (endFilter?.item)!, section: (endFilter?.section)!)
        
        for month in (from.section)...(to.section) {
            
            let dayCount = collectionView.numberOfItems(inSection: month)
            let fromDay = (month == from.section) ? from.item : 0
            let toDay = (month == to.section) ? to.item : (dayCount-1)
            
            for day in fromDay...toDay {
                let i = IndexPath(item: day, section: month)
                selectedDateRange.append(i)
                
            }
        }
    }

}

extension IndexPath {
    
    static func < (left: IndexPath, right: IndexPath) -> Bool {
        var before = Bool()
        if (left.section < right.section) {
            before = true
        } else if (left.item < right.item) && (left.section == right.section) {
            before = true
        } else {
            before = false
        }
        return before
    }
    
    static func > (left: IndexPath, right: IndexPath) -> Bool {
        var after = Bool()
        if (left.section > right.section) {
            after = true
        } else if (left.item > right.item) && (left.section == right.section) {
            after = true
        } else {
            after = false
        }
        return after
    }
}
