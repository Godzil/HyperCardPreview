//
//  ResourceSystem.swift
//  HyperCard
//
//  Created by Pierre Lorenzi on 03/03/2017.
//  Copyright © 2017 Pierre Lorenzi. All rights reserved.
//


/// A stack of resource forks. In Classic Mac OS, resource forks are stacked, from
/// local to global. When a resource is present in several forks, the first one has
/// precedence, so the global resources of the system can be overriden by local
/// resources in stacks.
public struct ResourceSystem {
    
    /// The resource forks in their order
    public var repositories: [ResourceRepository]   = []
    
    /// Main constructor, declared to be public
    public init() {}
    
    /// Finds a resource in the forks, respecting the order of precedence
    public func findResource<T>(ofType type: ResourceType<T>, withIdentifier identifier: Int) -> Resource<T>? {
        for repository in repositories {
            for resource in repository.resources {
                if let r = resource as? Resource<T>, r.type === type, r.identifier == identifier {
                    return r
                }
            }
        }
        return nil
    }
    
    /// Lists all the resources of a certain type. Respects the order of precedence.
    public func listResources<T>(ofType type: ResourceType<T>) -> [Resource<T>] {
        var list = [Resource<T>]()
        var identifiers = Set<Int>()
        for repository in repositories {
            let repositoryList = repository.resources.flatMap( {
                (resource: Any) -> Resource<T>? in
                if let r = resource as? Resource<T>, r.type === type, !identifiers.contains(r.identifier) {
                    identifiers.insert(r.identifier)
                    return r
                }
                return nil
            } )
            list.append(contentsOf: repositoryList)
        }
        return list
    }
    
}
