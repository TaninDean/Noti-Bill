//
//  FirestoreManager.swift
//  Noti-Bill
//
//  Created by ธนิน ผิวเหลืองสวัสดิ์ on 30/4/2567 BE.
//

import Firebase
import FirebaseFirestore

class FirestoreManager {
    private var db = Firestore.firestore()

    /// Adds data to a specified collection in Firestore
    /// - Parameters:
    ///   - uuid: The UUID of the document.
    ///   - collectionName: The name of the Firestore collection.
    ///   - data: Dictionary representing the data to be added to the Firestore collection.
    func addData(collectionName: String, uuid: String, data: [String: Any]) {
        let document = db.collection(collectionName).document(uuid)

        // Attempt to update the document by appending to the "bills" array
        document.updateData([
            "bills": FieldValue.arrayUnion([data])
        ]) { error in
            if let error = error {
                // If the document does not exist, there's an error on arrayUnion operation
                print("Error updating document: \(error)")
                // Create the document with the new array
                document.setData(["bills": [data]], merge: true) { error in
                    if let error = error {
                        print("Error creating document: \(error)")
                    } else {
                        print("Document created successfully!")
                    }
                }
            } else {
                print("Document updated successfully!")
            }
        }
    }
    
    func fetchBills(collectionName: String, uuid: String, completion: @escaping ([Any]?, Error?) -> Void) {
            let document = db.collection(collectionName).document(uuid)

            document.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    completion(nil, error)
                } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    let data = documentSnapshot.data()
                    let bills = data?["bills"] as? [Any] ?? []
                    print("Bills fetched successfully: \(bills)")
                    completion(bills, nil)
                } else {
                    print("Document does not exist")
                    completion([], nil)
                }
            }
        }
}


