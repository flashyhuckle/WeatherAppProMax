protocol StorageType<Object> {
    associatedtype Object
    
    func loadObjects() -> [Object]
    func saveObject(_ object: Object)
}
