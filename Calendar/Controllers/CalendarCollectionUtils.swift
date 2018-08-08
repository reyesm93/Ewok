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
            cell.dayLabel.text="\(day)"
            
            var isBefore = Bool()
            var isAfter = Bool()
            
            if limitsIndexPath != nil {
                if (limitsIndexPath?.count)! > 1 {
                    let firstTransaction = limitsIndexPath![0]
                    let lastTransaction = limitsIndexPath![1]
                    isBefore = indexPath < firstTransaction
                    isAfter = indexPath > lastTransaction
                    
                } else if limitsIndexPath?.count == 1 {
                    let onlyTransaction = limitsIndexPath![0]
                    isBefore = indexPath < onlyTransaction
                    isAfter = indexPath > onlyTransaction
                    
                }
            
            }
            
            if indexPath == todayIndexPath {
                cell.dayLabel.font = cell.dayLabel.font.bold
            }
            
            if selectedDateRange.contains(indexPath) {
                cell.backgroundColor = .black
                cell.dayLabel.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.dayLabel.textColor = .black
            }
            
            if isBefore || isAfter {
                cell.isUserInteractionEnabled = false
                cell.dayLabel.textColor = .gray
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let dateRangeType = dateRangeType else { return }
        
        switch dateRangeType {
        case .single:
            selectedDateRange.removeAll()
            selectedDateRange.append(indexPath)
        case .continuous:
            if startDate != nil {
                if endDate != nil {
                    restartRange(collectionView, indexPath)
                    endDate = nil
                } else {
                    if indexPath < startDate! {
                        restartRange(collectionView, indexPath)
                    } else if indexPath > startDate! {
                        selectedDateRange.removeAll()
                        endDate = indexPath
                        appendDateRange(collectionView)
                    }
                }
            } else {
                startDate = indexPath
                selectedDateRange.append(startDate!)
            }
        case .specific:
            if selectedDateRange.contains(indexPath) {
                if let index = selectedDateRange.index(of: indexPath) {
                    selectedDateRange.remove(at: index)
                }
            } else {
                selectedDateRange.append(indexPath)
            }
        }
        
        collectionView.reloadData()
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let monthHeader = calendarView.myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeader
        let month = calendarData.monthArray[indexPath.section]
        
        monthHeader.monthLbl.text = "   " + month.name

        return monthHeader

    }
    
    fileprivate func highlightCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell // The cell object at the corresponding index path or nil if the cell is not visible or indexPath is out of range. You should update your underlying model, which provides the data to the views.
        
        if cell.isHidden == false {
            cell.backgroundColor = .black
            cell.dayLabel.textColor = .white
        }
    }
    
    fileprivate func unHighlightCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if cell.isHidden == false {
            cell.backgroundColor = .clear
            cell.dayLabel.textColor = .black
        }
    }
    
    fileprivate func restartRange(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        selectedDateRange.removeAll()
        startDate = indexPath
        selectedDateRange.append(startDate!)
    }
    
    fileprivate func appendDateRange(_ collectionView: UICollectionView) {
        let from = IndexPath(item: (startDate?.item)!, section: (startDate?.section)!)
        let to = IndexPath(item: (endDate?.item)!, section: (endDate?.section)!)
        
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
