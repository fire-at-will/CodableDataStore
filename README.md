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

```Swift
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

### Using Other Data Stores
By default, CodableDataStore stores data in _UserDefaults_. This isn't ideal for any use case where you might be handling sensitive information.

#### Create a Custom CodableDataStoreEngine
For these cases, you may implement your own `CodableDataStoreEngine` class which handles the CRUD operations for a given data store. Once your implementation is complete, pass it to the `CodableDataStore` class to use it:

```Swift
let customDataStoreEngine = MyEngine()
let codableDataStore = CodableDataStore(engine: customDataStoreEngine)
```

#### Testing Custom CodableDataStoreEngines
To simplify testing `CodableDataStoreEngine` classes, a `CodableDataStoreEngineBaseTest` class has been provided which will test any class to the `CodableDataStoreEngine` protocol. To use the class, create a new testing class that extends from `CodableDataStoreEngineBaseTest` and provide your custom `CodableDataStoreEngine` object in the `setUp` function, as demonstrated below:

```Swift
import XCTest
@testable import CodableDataStore

class CodableDataStoreEngineUserDefaultsTests: CodableDataStoreEngineBaseTest {
    private var userDefaults: UserDefaults!

    // Provide the CodableDataStoreEngineBaseTest class with an engine to test
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
        
        codableDataStoreEngine = CodableDataStoreEngineUserDefaults(userDefaults: userDefaults)
    }
}
```

Once that has been done, your custom data store will be tested to the `CodableDataStoreEngine` spec.
