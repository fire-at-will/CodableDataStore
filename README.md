# CodableDataStore

`CodableDataStore` provides an easy way to persist and retrieve `Codable` structs for Swift applications!

### Usage

Everything you'll need is inside the `CodableDataStore` class. Let's grab an instance:

```Swift
import CodableDataStore

// ...

let codableDataStore = CodableDataStore()   // Defaults to using UserDefaults
```

From here, all basic CRUD operations are supported:

```
let myCodable = MyCodable(name: "fire-at-will", favoriteNumber: 64)
let myID = "qwerty"

do {
  // Create
  try codableDataStore.create(withID: myID, codable: myCodable)
  
  // Read
  let codableFromDataStore: MyCodable? = try codableDataStore.read(withId: myID)
  
  // Update
  let updatedCodable = MyCodable(name: "updated!", favoriteNumber: 777)
  
  // Throws if there is no existing codable with the ID myID.
  try codableDataStoreEngine.update(codableWithID: myID, withCodable: updatedCodable)
  
  // Inserts if there is no existing codable with the ID myID.
  try codableDataStoreEngine.updateOrCreate(codableWithID: myID, withCodable: updatedCodable)
  
  // Delete
  try codableDataStoreEngine.delete(codableWithID: myID)
} catch {
  print("Error: \(error.localizedDescription)")
}
```
