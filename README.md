# FluentTestApp
![Swift](http://img.shields.io/badge/swift-4.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-3.0-brightgreen.svg)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
![License](http://img.shields.io/badge/license-MIT-CCCCCC.svg)

FluentTestApp makes it really simple to get a testable Vapor app up and running, optionally seeding an SQLite in-memory database. Ideal for when you are building a library on top of Fluent and you  want to quickly get to testing your code, skipping all the setup. It contains a schema that touches most (hopefully more soon) basic datatypes and all basic relationships. 

## Installation

**FluentTestApp** is available through [Swift Package Manager](https://swift.org/package-manager/). To install, add the following to your Package.swift file.

```swift
let package = Package(
    name: "YourProject",
    dependencies: [
        ...
        .package(url: "https://github.com/Appsaurus/FluentTestApp", from: "0.1.0"),
    ],
    targets: [
      .testTarget(name: "YourApp", dependencies: ["FluentTestApp", ... ])
    ]
)
        
```
## Usage

### Setting up your test case
Create a test case inheriting from `FluentAppTestCase`.  Because everything is seeding during setup, you can immediately start making queries in your tests.

```swift
import XCTest
import Vapor
import FluentTestApp
import FluentTestModels

class ExampleAppTestCase: FluentAppTestCase {
	
	static var allTests = [
		("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
		("testQueries", testQueries) //Reference your tests here for Linux check
	]

	func testLinuxTestSuiteIncludesAllTests(){
		assertLinuxTestCoverage(tests: type(of: self).allTests)
	}

	func testQueries() throws{
		XCTAssertEqual(try ExampleModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleModelCount)
		XCTAssertEqual(try ExampleSiblingModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleSiblingModelCount)
		XCTAssertEqual(try ExampleChildModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleChildModelCount)
	}
}

```
### Registering routes

If your tests require routes to be setup, you can do that by overriding `routes(_:)` and registering them. Then you can easily execute requests against your routes using `executeRequest(headers:method:body:uri:queryitems:)`

```swift
override func routes(_ router: Router) throws {
	try super.routes(router)
	router.get("models") { request in
		return ExampleModel.query(on: request).all()
	}
}


func testModelsRoute() throws{
	let models: [ExampleModel] = try executeRequest(method: .GET, uri: "models").content.syncDecode([ExampleModel].self)
	XCTAssertEqual(models.count, ExampleModelsSeeder.exampleModelCount)
}
```
### Configuring database seed
By default, FluentTestApp will automatically seed an SQLite in-memory database with the schema from [FluentTestModels](https://github.com/Appsaurus/FluentTestModels) designed to make it easy to test various aspects of Fluent based libraries. This includes seeding of relationships between the models as well. If you don't want the database to automatically get seeded, set `autoSeed` to `false`. Additionally, you can implement your own Seeder in `configure(migrations)`. 

```swift
override open var autoSeed: Bool { return false }

open override func configure(migrations: inout MigrationConfig){
	super.configure(migrations: &migrations)
	migrations.add(model: YourCustomModel.self, database: .sqlite)		
	migrations.add(migration: YourCustomModelSeed.self, database: .sqlite)
}
```

For an example of how to implement a custom seeder, see  [FluentSeeder](https://github.com/Appsaurus/FluentSeeder).

## Contributing

We would love you to contribute to **FluentTestApp**, check the [CONTRIBUTING](https://github.com/Appsaurus/FluentTestApp/blob/master/CONTRIBUTING.md) file for more info.

## License

**FluentTestApp** is available under the MIT license. See the [LICENSE](https://github.com/Appsaurus/FluentTestApp/blob/master/LICENSE.md) file for more info.
