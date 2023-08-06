//
//  VATypingTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.04.2023.
//

import AsyncDisplayKit

open class VATypingTextNode: VATextNode {
    /// Time in milliseconds
    public private(set) var typingTime = 100
    /// Time in milliseconds
    public private(set) var erasingTime = 40
    public private(set) var offset = 0 {
        didSet { updateTyping() }
    }
    public private(set) var typingText: NSAttributedString?
    public private(set) var isRetyping = false
    public private(set) var isRandomizedTypingTime = true
    public var isTyping: Bool { timer != nil }

    private var newText: String?
    private var timer: Timer?

    /// Typing configuration
    ///
    /// - Parameters:
    ///   - typingTime: Character typing animation time in milliseconds
    ///   - erasingTime: Character erasing animation time in milliseconds
    ///   - offset: Visible text offset
    ///   - isRandomizedTypingTime: Randomize animation time in `0...time` range for typing and erasing
    public func configure(
        typingTime: Int? = nil,
        erasingTime: Int? = nil,
        offset: Int? = nil,
        isRandomizedTypingTime: Bool? = nil
    ) {
        if let typingTime {
            self.typingTime = typingTime
            if isTyping && !isRetyping {
                startTyping()
            }
        }
        if let erasingTime {
            self.erasingTime = erasingTime
            if isTyping && isRetyping {
                startTyping()
            }
        }
        if let offset {
            self.offset = offset
            updateTyping()
        }
        if let isRandomizedTypingTime {
            self.isRandomizedTypingTime = isRandomizedTypingTime
            if isTyping {
                startTyping()
            }
        }
    }

    public func startRetyping(to newText: String) {
        self.newText = newText
        isRetyping = true
        startTyping(isRetyping: isRetyping)
    }

    public func startTyping() {
        startTyping(isRetyping: isRetyping)
    }

    public func pauseTyping() {
        resetTimer()
    }

    public func resetTyping() {
        resetTimer()
        mainAsync(after: (typingTime * 2).interval) { [self] in
            offset = 0
            updateTyping()
        }
    }

    open override func configureTheme(theme: VATheme) {
        typingText = stringGetter(text, theme)
        updateTyping()
    }

    private func startTyping(isRetyping: Bool) {
        resetTimer()
        let isRandomized = isRandomizedTypingTime
        let time = isRetyping ? erasingTime : typingTime
        timer = Timer.scheduledTimer(
            withTimeInterval: time.interval,
            repeats: true,
            block: { [weak self] _ in
                if isRandomized {
                    mainAsync(after: Int.random(in: 0...time).interval) {
                        self?.updateTimerTyping()
                    }
                } else {
                    self?.updateTimerTyping()
                }
            }
        )
    }

    private func updateTimerTyping() {
        if isRetyping {
            offset -= 1
            if offset <= 0 {
                isRetyping = false
                text = newText
                startTyping(isRetyping: false)
            }
        } else {
            offset += 1
        }
    }

    private func updateTyping() {
        if let typingText {
            let mutableString = NSMutableAttributedString(attributedString: typingText)
            if offset < 0 {
                offset = 0
            } else if offset > typingText.string.utf16.count {
                offset = typingText.string.utf16.count
            }
            let length = typingText.string.utf16.count - offset
            mutableString.addAttributes(
                [.foregroundColor: UIColor.clear],
                range: NSRange(location: offset, length: length)
            )
            self.attributedText = mutableString
            if length == 0 {
                resetTimer()
            }
        } else {
            resetTimer()
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        resetTimer()
    }
}

private extension Int {
    var interval: TimeInterval { TimeInterval(self) / 1000 }
}
