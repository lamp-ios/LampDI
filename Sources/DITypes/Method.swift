import Foundation

final actor MyStateHolder {
    private(set) var state: Int = 0
    
    func set(state: Int) {
        self.state = state
    }
}

// MARK: - Usage

private func test() async {
    let holder = MyStateHolder()
    
    await holder.set(state: 5)
}
