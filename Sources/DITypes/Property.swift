import UIKit

final class MyDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Unimplemented")
    }
}

// MARK: - Usage

private func test() {
    let tableView = UITableView()
    let dataSource = MyDataSource()
    
    tableView.dataSource = dataSource
}
