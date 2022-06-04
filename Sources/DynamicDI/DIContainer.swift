enum Scope {
    case prototype
    case lazySingleton
}

struct Definition<Value> {
    let scope: Scope
    let factory: (Container) -> Value
}

final class Container {
    typealias Factory<Value> = (Container) -> Value
    
    var definitions: [ObjectIdentifier: Any] = [:]
    var singletons: [ObjectIdentifier: Any] = [:]
    
    func register<Value>(scope: Scope = .prototype, _ factory: @escaping Factory<Value>) {
        let valueType = ObjectIdentifier(Value.self)
        definitions[valueType] = Definition(scope: scope, factory: factory)
    }
    
    func resolve<Value>() -> Value {
        let valueType = ObjectIdentifier(Value.self)
        guard let definition = definitions[valueType] as? Definition<Value> else {
            fatalError()
        }
        
        switch definition.scope {
        case .prototype:
            return definition.factory(self)
        case .lazySingleton:
            if let existingInstance = singletons[valueType] as? Value {
                return existingInstance
            }
            let instance = definition.factory(self)
            singletons[valueType] = instance
            return instance
        }
    }
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


final class SuperService {
    let gateway: Gateway
    
    init(gateway: Gateway) {
        self.gateway = gateway
        print("Super SVC created")
    }
}


final class ViewModel {
    let service: Service
    let superService: SuperService
    
    init(service: Service, superService: SuperService) {
        self.service = service
        self.superService = superService
        print("VM created")
    }
}

@main
struct DynamicDIApp {
    static func main() {
        print("Dynamic DI")
    
        let container = Container()

        container.register(scope: .lazySingleton) { c in
            Service(gateway: c.resolve())
        }
        
        container.register(scope: .lazySingleton) { c in
            Gateway()
        }
        
        container.register { c in
            ViewModel(service: c.resolve(), superService: c.resolve())
        }
        
        container.register { c in
            SuperService(gateway: c.resolve())
        }

//        let service1 = container.resolve() as Service
//        let service2 = container.resolve() as Service
        
        
        let vm1 = container.resolve() as ViewModel
        let vm2 = container.resolve() as ViewModel
        
        print(vm1.superService.gateway === vm1.service.gateway)
        print(vm2.superService.gateway === vm2.service.gateway)
        print(vm1.superService.gateway === vm2.service.gateway)

//        print("Are services same: \(service1 === service2)")
//        print("Are gateways same: \(service1.gateway === service2.gateway)")
    }
}
