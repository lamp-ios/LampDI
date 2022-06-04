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
            let key = ObjectIdentifier(Value.self)
            if let value = container.singletons[key] as? Value {
                return value
            }
            let value = definition.factory(container)
            container.singletons[key] = value
            return value
        }
    }
}

@dynamicMemberLookup
final class Container {
    var singletons: [ObjectIdentifier: Any] = [:]
    
    subscript <Value>(dynamicMember dynamicMember: KeyPath<Assembly, Definition<Value>>) -> Resolver<Value> {
        return .init(
            container: self,
            definition: Assembly()[keyPath: dynamicMember]
        )
    }
}


final class Gateway {}
final class Service {
    let gateway: Gateway
    init(gateway: Gateway) {
        self.gateway = gateway
    }
}

final class Assembly {
    var gateway = Definition(scope: .lazySingleton) { container in
        Gateway()
    }
    
    var service = Definition { container in
        Service(
            gateway: container.gateway.resolve()
        )
    }
}

@main
struct StaticDIApp {
    static func main() {
        print("Static DI")
        
        let container = Container()
        let service1 = container.service.resolve()
        let service2 = container.service.resolve()
        
        print(ObjectIdentifier(service1))
        print(ObjectIdentifier(service2))
        print("Are services same: \(service1 === service2)")
        print("Are gateways same: \(service1.gateway === service2.gateway)")
    }
}
