//
//  ItemStore.swift
//  LootLogger
//
//  Created by Ahlam  on 09/04/1443 AH.
//

import UIKit

class ItemStore {
  
  var allItems = [Item]()
  
  
  let itemArchiveURL: URL = {
    let documentsDirectories =
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // يبحث عن طريق for in
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  
  
  @discardableResult func createItem() -> Item
  {
    
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
    
  }
  
  func removeItem(_ item: Item) {
    
    if let index = allItems.firstIndex(of: item) {
      allItems.remove(at: index)
      
    }
  }
  
  func moveItem(from fromIndex: Int, to toIndex: Int) {
    if fromIndex == toIndex {
      return }
    // Get reference to object being moved so you can reinsert it
    let movedItem = allItems[fromIndex]
    // Remove item from array
    allItems.remove(at: fromIndex)
    // Insert item in array at new location
    allItems.insert(movedItem, at: toIndex)
  }
  
  //لخطأ في السطر الذي يستدعي الترميز (_ :) يقول: يمكن إجراء المكالمة ، لكن لم يتم وضع علامة "try" عليه ولا يتم معالجة الخطأ. يشير خطأ المترجم هذا إلى أنك لا تتعامل مع احتمال فشل عملية الترميز
  @objc func saveChanges() -> Bool {
    print("Saving items to: \(itemArchiveURL)")
    do {
      // هنا عندي ممكن تطلع مشكله ف احدد تري ان هنا الخطا ممكن يكون للتعزيز فكرة الخطا
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(allItems)
      try data.write(to: itemArchiveURL, options: [.atomic])
      
      print("Saved all of the items")
      return true
    } catch let encodingError { //proprity list
      
      print("Error encoding allItems: \(encodingError)")
      return false
      
    }
    //      let data = encoder.encode(allItems)
  }
  
  init() {
    do {
      let data = try Data(contentsOf: itemArchiveURL)
      let unarchiver = PropertyListDecoder()
      let items = try
unarchiver.decode([Item].self, from: data)
      allItems = items
    } catch {
      print("Error reading in saved items: \(error)")
    }
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(saveChanges),
                                   name: UIScene.didEnterBackgroundNotification,
                                   object: nil)
  }
  
  
  
  
  
  
}

