import Foundation

final class MyViewController {
    private var viewModel: MyViewModel
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
    }
}

final class MyViewModel {
    private var superSvc: SuperService
    
    init(superSvc: SuperService = .shared) {
        self.superSvc = superSvc
    }
}

final class SuperService {
    static let shared: SuperService = .init()
    
    private init() {
    }
}


// MARK: - Usage

private func test() {
//    let service = SuperService()
    
    let viewModel = MyViewModel()
    
    let viewController = MyViewController(
        viewModel: viewModel
    )
    
    dump(viewController)
}
