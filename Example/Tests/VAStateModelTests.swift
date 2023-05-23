//
//  VAStateModelTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VAStateModelTests: XCTestCase {
    private var sut: VAStateModel<Actionable, Eventable, State>!
    
    override func tearDown() {
        sut = nil
    }
    
    func test_event_onFirst() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        sut.reduce { (e: FirstEvent) -> State in
            State(a: 2)
        }
        spy.wait {
            self.sut.perform(FirstEvent())
        }
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_event_onFirstS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        sut.reduceS { (e: FirstEvent, state) -> State in
            XCTAssertEqual(State(a: 1), state)
            return State(a: 2)
        }
        spy.wait {
            self.sut.perform(FirstEvent())
        }
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_event_onFirstRun() {
        sut = VAStateModel(initial: .init())
        let expect = expectation(description: "")
        sut.reduceRun { (e: FirstEvent) in
            expect.fulfill()
        }
        sut.perform(FirstEvent())
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_event_onFirstRunS() {
        sut = VAStateModel(initial: .init())
        let expect = expectation(description: "")
        sut.reduceRunS { (e: FirstEvent, state) in
            XCTAssertEqual(State(a: 1), state)
            expect.fulfill()
        }
        sut.perform(FirstEvent())
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_action_onFirst() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        sut.on { (a: FirstAction) in
            FirstEvent()
        }
        sut.reduce { (e: FirstEvent) -> State in
            State(a: 2)
        }
        spy.wait {
            self.sut.execute(FirstAction())
        }
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_action_onFirstS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        sut.onS { (a: FirstAction, state) in
            XCTAssertEqual(State(a: 1), state)
            return FirstEvent()
        }
        sut.reduce { (e: FirstEvent) -> State in
            State(a: 2)
        }
        spy.wait {
            self.sut.execute(FirstAction())
        }
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_action_onFirstRun() {
        sut = VAStateModel(initial: .init())
        let expect = expectation(description: "")
        sut.onRun { (a: FirstAction) in
            expect.fulfill()
        }
        sut.execute(FirstAction())
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_action_onFirstRunS() {
        sut = VAStateModel(initial: .init())
        let expect = expectation(description: "")
        sut.onRunS { (a: FirstAction, state) in
            XCTAssertEqual(State(a: 1), state)
            expect.fulfill()
        }
        sut.execute(FirstAction())
        
        wait(for: [expect], timeout: 1)
    }
    
    func test_action_sequestial() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.on(sequential: { (a: DelayAction) in
            Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 7)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2), State(a: 3)], spy.result)
    }
    
    func test_action_droppable() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.on(droppable: { (a: DelayAction) in
            Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_action_restartable() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.on(restartable: { (a: DelayAction) in
            Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 3)], spy.result)
    }
    
    func test_action_concurrent() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.on(concurrent: { (a: DelayAction) in
            Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 3))
        sut.execute(DelayAction(delay: 2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2), State(a: 3)], spy.result)
    }
    
    func test_action_sequestialS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.onS(sequential: { (a: DelayAction, state) in
            XCTAssertEqual(State(a: 1), state)
            return Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 7)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2), State(a: 3)], spy.result)
    }
    
    func test_action_droppableS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.onS(droppable: { (a: DelayAction, state) in
            XCTAssertEqual(State(a: 1), state)
            return Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 2), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2)], spy.result)
    }
    
    func test_action_restartableS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.onS(restartable: { (a: DelayAction, state) in
            XCTAssertEqual(State(a: 1), state)
            return Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 2))
        sut.execute(DelayAction(delay: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 3)], spy.result)
    }
    
    func test_action_concurrentS() {
        sut = VAStateModel(initial: .init())
        let spy = spy(sut.stateObs)
        let expect = expectation(description: "")
        sut.onS(concurrent: { (a: DelayAction, state) in
            XCTAssertEqual(State(a: 1), state)
            return Observable<Int>.timer(.seconds(a.delay), scheduler: MainScheduler.asyncInstance)
                .map { _ in DelayEvent(delay: a.delay) }
        })
        sut.reduce { (e: DelayEvent) -> State in
            State(a: e.delay)
        }
        sut.execute(DelayAction(delay: 3))
        sut.execute(DelayAction(delay: 2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
        
        XCTAssertEqual(State(a: 3), sut.state)
        XCTAssertEqual([State(a: 1), State(a: 2), State(a: 3)], spy.result)
    }
}

struct State: Equatable {
    var a: Int = 1
}

protocol Actionable {}

protocol Eventable {}

struct FirstEvent: Eventable {}

struct SecondEvent: Eventable {}

struct FirstAction: Actionable {}

struct SecondAction: Actionable {}

struct DelayAction: Actionable {
    let delay: Int
}

struct DelayEvent: Eventable {
    let delay: Int
}
