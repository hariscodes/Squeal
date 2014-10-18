import Quick
import Nimble
import Squeal
import SquealSpecHelpers

class BindableSpec: QuickSpec {
    override func spec() {
        
        var database : Database!
        var statement : Statement!
        var error : NSError?
        
        beforeEach {
            database = Database.openTemporaryDatabase()
            database.execute("CREATE TABLE people (personId INTEGER PRIMARY KEY, name TEXT, age REAL, is_adult INTEGER, photo BLOB)")
            database.execute("INSERT INTO people (name, age, is_adult, photo) VALUES (\"Amelia\", 1.5, 0, NULL),(\"Brian\", 43.375, 1, X''),(\"Cara\", NULL, 1, X'696D616765')")
            // 696D616765 is "image" in Hex.
        }
        
        afterEach {
            statement = nil
            database = nil
            error = nil
        }
        
        describe("Statement.bind(parameters:error:)") {
            
            it("binds String values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE name IS ?")
                statement.bind("Brian")
            
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Int values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(Int(1))

                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Int64 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(Int64(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Int32 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(Int32(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Int16 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(Int16(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Int8 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(Int8(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds UInt64 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(UInt64(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds UInt32 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(UInt32(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds UInt16 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(UInt16(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds UInt8 values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId IS ?")
                statement.bind(UInt8(1))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Double values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE age > ?")
                statement.bind(Double(43.374))

                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Float values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE age > ?")
                statement.bind(Float(43.374))
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds Bool values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE is_adult IS ?")
                statement.bind(false)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }

            it("binds blob values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE photo IS ?")
                statement.bind(["image".dataUsingEncoding(NSUTF8StringEncoding)], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Cara"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds empty blob values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE photo IS ?")
                statement.bind([NSData()], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds NULL blob values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE photo IS ?")
                statement.bind([nil], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Amelia"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds nil values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE age IS ?")
                statement.bind([nil], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Cara"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds multiple values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId > ? AND personId < ?")
                statement.bind([1, 3], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
        }

        describe("Statement.bind(namedParameters:error:)") {
            
            it("binds named values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE name IS $NAME")
                statement.bind(namedParameters:[ "$NAME": "Brian" ], error:nil)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
            it("binds multiple values") {
                statement = database.prepareStatement("SELECT * FROM people WHERE personId > $MIN_ID AND personId < $MAX_ID")
                statement.bind(namedParameters:["$MIN_ID": 1, "$MAX_ID": 3], error:&error)
                
                expect(statement.next()).to(beTruthy())
                expect(statement.stringValue("name")).to(equal("Brian"))
                expect(statement.next()).to(beFalsy())
            }
            
        }

    }
}
