final class Gateway {
}

final class Service {
    let gateway: Gateway

    init(gateway: Gateway) {
        self.gateway = gateway
    }
}

final class Environment {
    static var current: Environment = .init()
    
    var gateway: Gateway = .init()
    
    lazy var service: Service = .init(gateway: self.gateway)
}

@main
struct ServiceLocatorApp {
    static func main() {
        print("Service Locator")
        
        let env = Environment.current
        
        let service1 = env.service
        let service2 = env.service
        
        print("Are services same: \(service1 === service2)")
        print("Are gateways same: \(service1.gateway === service2.gateway)")
    }
}
