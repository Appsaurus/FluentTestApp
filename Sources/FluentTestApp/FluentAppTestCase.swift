//
//  FluentTestAppTestCase.swift
//  FluentTestApp
//
//  Created by Brian Strobach on 6/4/18.
//

import VaporTestUtils
import Vapor
import Fluent
import FluentSQLite
import FluentTestUtils
import FluentSeeder
import FluentTestModels

open class FluentAppTestCase: FluentTestCase{
	let sqlite: SQLiteDatabase = try! SQLiteDatabase(storage: .memory)
	open var autoSeed: Bool { return true }

    open override func register(_ services: inout Services) throws {
		try super.register(&services)
		try services.register(FluentSQLiteProvider())
		services.register(sqlite)
	}
	open override func configure(databases: inout DatabasesConfig) throws{
		try super.configure(databases: &databases)
		databases.add(database: sqlite, as: .sqlite)
	}

	open override func configure(migrations: inout MigrationConfig){
		super.configure(migrations: &migrations)
		migrations.add(model: ExampleModel.self, database: .sqlite)
		migrations.add(model: ExampleSiblingModel.self, database: .sqlite)
		migrations.add(model: ExampleChildModel.self, database: .sqlite)
		migrations.add(model: ExampleModelSiblingPivot.self, database: .sqlite)

		guard autoSeed else { return }
		migrations.add(migration: ExampleModelsSeeder.self, database: .sqlite)
	}
}
