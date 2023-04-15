//
//  NetworkLogger.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

protocol NetworkLogger {

    func log(request: URLRequest, response: URLResponse, data: Data?, date: Date)
    func log(error: Error, request: URLRequest, date: Date)
}

class DebugNetworkLogger: NetworkLogger {

    func log(request: URLRequest, response: URLResponse, data: Data?, date: Date) {
#if DEBUG
        logRequestInfo(request)
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode ?? -1
        let url = response.url?.absoluteString ?? ""
        let now = Date()
        let result = """

        💪 Response info begin 👇
        URL: \(url)
        Request time: \(date.readableString)
        Response time: \(now.readableString)
        \(requestDurationTime(startDate: date, endDate: now))
        StatusCode: \(statusCode)
        Response data:
        \(JSONSerialization.prettyPrinted(data: data))
        💪 Response info end 👌

        """
        print(result)
#endif
    }

    func log(error: Error, request: URLRequest, date: Date) {
#if DEBUG
        let now = Date()
        let url = request.url?.absoluteString ?? ""
        print("""

        😱 Error info begin 🤔
        Request time: \(date.readableString)
        Response time: \(now.readableString)
        \(requestDurationTime(startDate: date, endDate: now))
        URL: \(url)
        Description: \(error.localizedDescription),
        Error: \(error)
        😱 Error info end 🤨

        """)
#endif
    }

    private func logRequestInfo(_ request: URLRequest) {
        let method = String(describing: request.httpMethod ?? "")
        let headers = request.allHTTPHeaderFields ?? [:]
        let url = request.url?.absoluteString ?? ""
        var result = """

        📡 Request info begin 🤞
        URL: \(url)
        Method: \(method)
        Headers: \(headers.map { "\n--> \($0.key): \($0.value)" }.joined())

        """
        if let httpBody = request.httpBody {
            result += """

            Parameters:
            \(JSONSerialization.prettyPrinted(data: httpBody))

            """
        }

        result += "📡 Request info end 👀"
        print(result)
    }

    private func requestDurationTime(startDate: Date, endDate: Date) -> String {
        let duration = (endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970)
        return "Request duration time: \(String(format: "%.3f", duration)) s."
    }
}

private extension JSONSerialization {

    static func prettyPrinted(data: Data?) -> String {
        guard let data else {
            return "Empty data."
        }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return """
            JSONSerialization error: \(error.localizedDescription)
            Fallback to string:
            \(String(data: data, encoding: .utf8) ?? "")
            """
        }
    }
}
