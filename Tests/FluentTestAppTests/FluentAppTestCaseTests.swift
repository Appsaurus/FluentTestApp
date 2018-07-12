
import XCTest
import FluentTestApp
import Vapor
import FluentTestModels

class FluentAppTestCaseTests: FluentAppTestCase {
	//MARK: Linux Testing
	static var allTests = [
		("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
		("testSeed", testSeed),
		("testModelsRoute", testModelsRoute)
	]

	func testLinuxTestSuiteIncludesAllTests(){
		assertLinuxTestCoverage(tests: type(of: self).allTests)
	}

	override func routes(_ router: Router) throws {
		try super.routes(router)
		router.get("models") { request in
			return ExampleModel.query(on: request).all()
		}
	}

	func testSeed() throws {
		XCTAssertEqual(try ExampleModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleModelCount)
		XCTAssertEqual(try ExampleSiblingModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleSiblingModelCount)
		XCTAssertEqual(try ExampleChildModel.query(on: request).count().wait(), ExampleModelsSeeder.exampleChildModelCount)
	}
	func testModelsRoute() throws{
		let models: [ExampleModel] = try executeRequest(method: .GET, path: "models").content.syncDecode([ExampleModel].self)
		XCTAssertEqual(models.count, ExampleModelsSeeder.exampleModelCount)
	}
}

