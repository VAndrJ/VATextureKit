//
//  VATypingTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.04.2023.
//

import AsyncDisplayKit
import RxSwift

open class VATypingTextNode: VATextNode {
    /// Time in milliseconds
    public private(set) var characterTypingTime = 100
    /// Time in milliseconds
    public private(set) var characterErasingTime = 40
    public private(set) var offset = 0 {
        didSet { updateTyping() }
    }
    public private(set) var typingText: NSAttributedString?
    public private(set) var isRetyping = false
    public private(set) var isRandomizedTypingTime = true
    public var isTyping: Bool { timerDisposable != nil }

    private var newText: String?
    private var timerDisposable: Disposable?

    /// Typing configuration
    ///
    /// - Parameters:
    ///   - characterTypingTime: Typing animation time in milliseconds
    ///   - characterErasingTime: Erasing animation time in milliseconds
    ///   - offset: Visible text offset
    ///   - isRandomizedTypingTime: Randomize animation time in `0...time` range for typing and erasing
    public func configure(
        characterTypingTime: Int? = nil,
        characterErasingTime: Int? = nil,
        offset: Int? = nil,
        isRandomizedTypingTime: Bool? = nil
    ) {
        if let characterTypingTime {
            self.characterTypingTime = characterTypingTime
            if isTyping && !isRetyping {
                startTyping()
            }
        }
        if let characterErasingTime {
            self.characterErasingTime = characterErasingTime
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
        offset = 0
        updateTyping()
    }

    open override func configureTheme() {
        typingText = stringGetter(text, theme)
        updateTyping()
    }

    private func startTyping(isRetyping: Bool) {
        resetTimer()
        let isRandomized = isRandomizedTypingTime
        let time = isRetyping ? characterErasingTime : characterTypingTime
        timerDisposable = Observable<Int>
            .timer(
                .milliseconds(isRandomized ? Int.random(in: 0...time) : time),
                period: .milliseconds(time),
                scheduler: MainScheduler.asyncInstance
            )
            .subscribe(onNext: { [weak self] _ in
                if isRandomized {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 0...time))) {
                        self?.updateTimerTyping()
                    }
                } else {
                    self?.updateTimerTyping()
                }
            })
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
        timerDisposable?.dispose()
        timerDisposable = nil
    }

    deinit {
        resetTimer()
    }
}
