//
//  VACountingTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.07.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VACountingTextNode: VATextNode {
    public struct Configuration {
        public let timingFunction: CAMediaTimingFunctionName
        public let animationDuration: TimeInterval
        public let rate: Double
        public let preferredFramesPerSecond: Int
        public let format: (Int) -> String

        public init(
            timingFunction: CAMediaTimingFunctionName = .easeIn,
            animationDuration: TimeInterval = 1.0,
            rate: Double = 3.0,
            preferredFramesPerSecond: Int = 30,
            format: @escaping (Int) -> String = { "Count: \($0)" }
        ) {
            self.timingFunction = timingFunction
            self.animationDuration = animationDuration
            self.rate = rate
            self.preferredFramesPerSecond = preferredFramesPerSecond
            self.format = format
        }
    }

    public var configuration = Configuration()
    public private(set) lazy var value = Int(text ?? configuration.format(0))

    private var beginValue = 0
    private var targetValue = 0
    private var progressTime = 0.0
    private var lastUpdateTime = 0.0
    private var totalTime = 0.0
    private var displayLink: CADisplayLink?
    private var currentValue: Int {
        if progressTime >= totalTime {
            return targetValue
        }
        
        return beginValue + Int(configuration.timingFunction.getValue(for: progressTime / totalTime, rate: configuration.rate) * Double(targetValue - beginValue))
    }

    public func updateCount(to newValue: Int) {
        if let value {
            count(from: value, to: newValue)
        } else {
            text = configuration.format(newValue)
        }
        value = newValue
    }

    private func count(from: Int, to: Int) {
        beginValue = from
        targetValue = to
        cancelCounting()
        if configuration.animationDuration.isZero {
            text = configuration.format(to)
        } else {
            progressTime = 0
            totalTime = configuration.animationDuration
            lastUpdateTime = Date.timeIntervalSinceReferenceDate
            addDisplayLink()
        }
    }

    private func cancelCounting() {
        displayLink?.invalidate()
        displayLink = nil
        progressTime = totalTime
    }

    private func addDisplayLink() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateText)
        )
        if #available(iOS 15.0, *) {
            let rate = Float(configuration.preferredFramesPerSecond)
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: rate, maximum: rate, preferred: rate)
        } else {
            displayLink?.preferredFramesPerSecond = configuration.preferredFramesPerSecond
        }
        displayLink?.add(to: .main, forMode: .default)
        displayLink?.add(to: .main, forMode: .tracking)
    }

    @objc private func updateText() {
        let now = Date.timeIntervalSinceReferenceDate
        progressTime += now - lastUpdateTime
        lastUpdateTime = now
        if progressTime >= totalTime {
            cancelCounting()
        }
        text = configuration.format(currentValue)
    }
}

private extension CAMediaTimingFunctionName {

    func getValue(for value: Double, rate: Double) -> Double {
        var to = value
        switch self {
        case .easeIn:
            return pow(to, rate)
        case .easeInEaseOut:
            var sign: Double = 1
            if Int(rate) % 2 == 0 {
                sign = -1
            }
            to *= 2
            
            return to < 1 ? 0.5 * pow(to, rate) : (sign * 0.5) * (pow(to - 2, rate) + sign * 2)
        case .easeOut:
            return 1.0 - pow((1.0 - to), rate)
        default:
            return to
        }
    }
}
