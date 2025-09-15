//
//  CoreDataManager.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 09/09/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - Save
    func saveFavorite(product: Product) {
        if isInFavorites(id: product.id) { return }

        let item = FavoriteProduct(context: context)
        item.id = Int16(product.id)
        item.imageName = product.imageName
        item.imageURL = product.imageURL
        item.discountPercentage = product.discountPercentage
        item.productName = product.productName
        item.priceAfterDiscount = Int32(product.priceAfterDiscount)
        item.originalPrice = Int32(product.originalPrice)
        item.promoText = product.promoText
        item.ratingText = product.ratingText
        item.storeName = product.storeName
        item.productDescription = product.description

        saveContext()
    }
    
    // MARK: - Fetch
    func fetchFavorites() -> [FavoriteProduct] {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productName", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchFavoriteProducts() -> [Product] {
        return fetchFavorites().map { $0.toProduct() }
    }
    
    // MARK: - Delete
    func deleteFavorite(id: Int) {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        if let result = try? context.fetch(request), let first = result.first {
            context.delete(first)
            saveContext()
        }
    }
    
    // MARK: - Check
    func isInFavorites(id: Int) -> Bool {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Saved to Core Data")
            } catch {
                print("❌ Error saving Core Data: \(error)")
            }
        }
    }
}
