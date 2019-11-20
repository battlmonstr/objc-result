import Foundation

/**
 Converter between `OCResult` and the standard Swift `Result<Success, Failure>` type.
 */
extension OCResult {
    /**
     Converts an `OCResult` to the Swift's `Result` object.
     The value type becomes `Any`, but you can use `Result.map()` or `Result.flatMap()` to convert it to a desired type.
     */
    public func toSwift() -> Result<Any, Error> {
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

    /**
     Converts a given Swift's `Result` to an `OCResult` object.
     */
    public static func make<Success : Any, Failure : Error>(fromSwiftResult result: Result<Success, Failure>) -> OCResult {
        switch result {
        case .success(let value):
            return OCResult.success(value)
        case .failure(let error):
            return OCResult.failure(error)
        }
    }
}
