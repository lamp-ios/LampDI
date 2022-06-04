import Foundation

enum Scope {
    case prototype
    case lazySingleton
}

final class Container {
    typealias ValueFactory<Value> = (Container) -> Value
    
    struct Definition {
        let scope: Scope
        let factory: ValueFactory<Any>
    }
    
    private var definitions: [ObjectIdentifier: Definition] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    func register<Value>(scope: Scope = .prototype, _ factory: @escaping ValueFactory<Value>) {
        let key = ObjectIdentifier(Value.self)
        definitions[key] = .init(scope: scope, factory: factory)
    }
    
    func resolve<Value>() -> Value {
        let key = ObjectIdentifier(Value.self)
        guard let definition = definitions[key] else {
            fatalError()
        }
        
        switch definition.scope {
        case .prototype:
            guard let value = definition.factory(self) as? Value else {
                fatalError()
            }
            return value
        case .lazySingleton:
            if let value = singletons[key] as? Value {
                return value
            }
            guard let value = definition.factory(self) as? Value else {
                fatalError()
            }
            singletons[key] = value
            return value
        }
    }
}

@main
struct TestApp {
    static func main() {
        final class Gateway {}
        final class Service {
            let gateway: Gateway
            init(gateway: Gateway) {
                self.gateway = gateway
            }
        }
        
        let container = Container()
        
        container.register(scope: .lazySingleton) { container in
            Service(gateway: container.resolve())
        }
        
        container.register(scope: .lazySingleton) { container in
            Gateway()
        }
        
        let service1 = container.resolve() as Service
        let service2 = container.resolve() as Service
        
        dump(service1)
        dump(service2)
        print(service1 === service2)
        print(service1.gateway === service2.gateway)
    }
}
