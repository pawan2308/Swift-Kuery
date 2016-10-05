/**
 Copyright IBM Corporation 2016
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


import Foundation

public struct Update : Query {
    public let table: Table
    public private (set) var whereClause: Where?
    private let valueTuples: [(Field, ValueType)]
    
    public func build(queryBuilder: QueryBuilder) -> String {
        let values = valueTuples.map {key, value in "\(key.build(queryBuilder: queryBuilder)) = \(packType(value))" }.joined(separator: ", ")
        var result = "UPDATE " + table.build(queryBuilder: queryBuilder) + " SET \(values)"
        if let whereClause = whereClause {
            result += " WHERE " + whereClause.build(queryBuilder: queryBuilder)
        }
        return result
    }
    
    public init(table: Table, set: [(Field, ValueType)], conditions: Where?=nil) {
        self.table = table
        self.valueTuples = set
        self.whereClause = conditions
    }
    
//    public mutating func `where`(_ conditions: Where) {
//        whereClause = conditions
//    }
    
    public func `where`(_ conditions: Where) -> Update {
        var new = self
        new.whereClause = conditions
        return new
    }

}
