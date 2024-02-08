import Network

class PathMonitor {
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    
    var isNetworkOn: Bool {
        return status == .satisfied
    }
    
    init() {
        monitor.pathUpdateHandler = { [ weak self ] path in
            self?.status = path.status
        }
        monitor.start(queue: DispatchQueue(label: "openweather"))
    }
    
    deinit {
        monitor.cancel()
    }
}
