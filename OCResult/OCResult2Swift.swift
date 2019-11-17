import Foundation

extension OCResult {
    func toSwift() -> Result<Any, Error> {
        let result = self
        switch result.kind {
        case .success:
            return Result.success(result.value)
        case .failure:
            return Result.failure(result.error)
        default:
            fatalError("Unexpected OCResult kind \(result.kind).")
        }
    }

    static func make<Success : AnyObject, Failure : Error>(fromSwiftResult result: Result<Success, Failure>) -> OCResult {
        switch result {
        case .success(let value):
            return OCResult.success(value)
        case .failure(let error):
            return OCResult.failure(error)
        }
    }
}
