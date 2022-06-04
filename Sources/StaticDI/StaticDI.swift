enum Scope {
    case prototype
    case lazySingleton
}

struct Definition<Value> {
    var scope: Scope = .prototype
    var factory: (Container) -> Value
}

struct Resolver<Value> {
    let container: Container
    let definition: Definition<Value>

    func resolve() -> Value {
        switch definition.scope {
        case .prototype:
            return definition.factory(container)
        case .lazySingleton:
            let type = ObjectIdentifier(Value.self)
            if let existingInsptance = container.singletons[type] as? Value {
                return existingInsptance
            }
            let instance = definition.factory(container)
            container.singletons[type] = instance
            return instance
        }
    }
}

@dynamicMemberLookup
final class Container {
    var singletons: [ObjectIdentifier: Any] = [:]
}


final class Gateway {
    init() {
        print("GW created")
    }
}

final class Service {
    let gateway: Gateway
    
    init(gateway: Gateway) {
        self.gateway = gateway
        print("SVC created")
    }
}

final class GatewaysAssembly: AssemblyType {
    var gateway = Definition(scope: .lazySingleton) { c in
        Gateway()
    }
}

protocol AssemblyType {
    init()
}

extension Container {
    func resolver<Assembly: AssemblyType, Value>(for definitionKeyPath: KeyPath<Assembly, Definition<Value>>) -> Resolver<Value> {
        return .init(
            container: self,
            definition: Assembly.init()[keyPath: definitionKeyPath]
        )
    }
}

extension Container {
    subscript <Value>(dynamicMember definitionKeyPath: KeyPath<GatewaysAssembly, Definition<Value>>) -> Resolver<Value> {
        return resolver(for: definitionKeyPath)
    }
}

final class ServicesAssembly: AssemblyType {
    var service = Definition(scope: .lazySingleton) { c in
        Service(gateway: c.gateway.resolve())
    }
}

extension Container {
    subscript <Value>(dynamicMember definitionKeyPath: KeyPath<ServicesAssembly, Definition<Value>>) -> Resolver<Value> {
        return resolver(for: definitionKeyPath)
    }
}

@main
struct StaticDIApp {
    static func main() {
        print("Static DI")
        
        let container = Container()
        let service1 = container.service.resolve()
        let service2 = container.service.resolve()
        
        print("Are services same: \(service1 === service2)")
        print("Are gateways same: \(service1.gateway === service2.gateway)")
    }
}
