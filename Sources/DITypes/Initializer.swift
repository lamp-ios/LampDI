import Foundation
import UIKit

final class MyViewController {
    private var viewModel: MyViewModel
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
    }
}

final class MyViewModel {
    private var superSvc: SuperService
    
    init(superSvc: SuperService) {
        self.superSvc = superSvc
    }
}

final class SuperService {
    init() {
    }
}


// MARK: - Usage

private func test() {
    let service = SuperService()
    let viewModel = MyViewModel(
        superSvc: service
    )
    let viewController = MyViewController(
        viewModel: viewModel
    )
    
    dump(viewController)
}
