//
//  List+Rx.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa
@_exported import Differentiator

/// Provides custom animation styles for insertion, deletion, and reloading behavior.
///
/// Properties
/// `animatedOnInit`: determines whether the animation is enabled or not on init.
/// `animated`: determines whether the animation is enabled or not.
/// `insertAnimation`: defines the animation style for insertion.
/// `reloadAnimation`: defines the animation style for reloading.
/// `deleteAnimation`: defines the animation style for deletion.
public struct AnimationConfiguration {
    public let animatedOnInit: Bool
    public let animated: Bool
    public let insertAnimation: UITableView.RowAnimation
    public let reloadAnimation: UITableView.RowAnimation
    public let deleteAnimation: UITableView.RowAnimation
    
    public init(
        animatedOnInit: Bool = false,
        animated: Bool = true,
        insertAnimation: UITableView.RowAnimation = .automatic,
        reloadAnimation: UITableView.RowAnimation = .automatic,
        deleteAnimation: UITableView.RowAnimation = .automatic
    ) {
        self.animatedOnInit = animatedOnInit
        self.animated = animated
        self.insertAnimation = insertAnimation
        self.reloadAnimation = reloadAnimation
        self.deleteAnimation = deleteAnimation
    }
}

extension Array where Element: SectionModelType {
    
    mutating func moveFromSourceIndexPath(_ sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let sourceSection = self[sourceIndexPath.section]
        var sourceItems = sourceSection.items
        let sourceItem = sourceItems.remove(at: sourceIndexPath.item)
        let sourceSectionNew = Element(original: sourceSection, items: sourceItems)
        self[sourceIndexPath.section] = sourceSectionNew
        let destinationSection = self[destinationIndexPath.section]
        var destinationItems = destinationSection.items
        destinationItems.insert(sourceItem, at: destinationIndexPath.item)
        self[destinationIndexPath.section] = Element(original: destinationSection, items: destinationItems)
    }
}

extension ObservableType {
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void) -> Disposable where DelegateProxy.ParentObject: ASDisplayNode, DelegateProxy.Delegate: AnyObject {
        let proxy = DelegateProxy.proxy(for: object)
        // disposable needs to be disposed on the main thread
        let unregisterDelegate = ScheduledDisposable(
            scheduler: MainScheduler.instance,
            disposable: DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
        )
        // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
        object.layoutIfNeeded()
        let subscription = asObservable()
            .observe(on: MainScheduler())
            .catch { error in
                bindingError(error)
                return Observable.empty()
            }
        // source can never end, otherwise it would release the subscriber, and deallocate the data source
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe { [weak object] (event: Event<Element>) in
                if let object {
                    assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                }
                binding(proxy, event)
                switch event {
                case let .error(error):
                    bindingError(error)
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
        return Disposables.create { [weak object] in
            subscription.dispose()
            object?.layoutIfNeeded()
            unregisterDelegate.dispose()
        }
    }
}

public enum NodeTransition {
    case animated
    case reload
}

enum RxDataSourceTextureError: Error {
    case outOfBounds(indexPath: IndexPath)
}

func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
#if DEBUG
    rxFatalError(error)
#else
    print(error)
#endif
}

/// Used as a runtime check to ensure that methods that are intended to be abstract (i.e., they should be implemented in subclasses) are not called directly on the superclass.
func rxAbstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    rxFatalError(message, file: file, line: line)
}

func rxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    fatalError(lastMessage(), file: file, line: line)
}

func rxFatalErrorInDebug(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
#if DEBUG
    fatalError(lastMessage(), file: file, line: line)
#else
    print("\(file):\(line): \(lastMessage())")
#endif
}

func rxDebugFatalError(_ error: Error) {
    rxDebugFatalError("\(error)")
}

func rxDebugFatalError(_ message: String) {
#if DEBUG
    fatalError(message)
#else
    print(message)
#endif
}

// MARK: casts

func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    return castOrFatalError(value)
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: AnyObject) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

func castOrFatalError<T>(_ value: AnyObject?, message: String) -> T {
    guard let result = value as? T else {
        rxFatalError(message)
    }
    return result
}

func castOrFatalError<T>(_ value: Any?) -> T {
    guard let result = value as? T else {
        rxFatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    return result
}

let dataSourceNotSet = "Set DataSource"
let delegateNotSet = "Set Delegate"

func indexSet(_ values: [Int]) -> IndexSet {
    let indexSet = NSMutableIndexSet()
    for i in values {
        indexSet.add(i)
    }
    return indexSet as IndexSet
}

extension ASTableNode: SectionedNodeType {
    
    public func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        insertRows(at: paths, with: animationStyle)
    }
    
    public func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        deleteRows(at: paths, with: animationStyle)
    }
    
    public func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath) {
        moveRow(at: from, to: to)
    }
    
    public func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        reloadRows(at: paths, with: animationStyle)
    }
    
    public func insertSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        insertSections(indexSet(sections), with: animationStyle)
    }
    
    public func deleteSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        deleteSections(indexSet(sections), with: animationStyle)
    }
    
    public func moveSection(_ from: Int, to: Int) {
        moveSection(from, toSection: to)
    }
    
    public func reloadSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        reloadSections(indexSet(sections), with: animationStyle)
    }
}

extension ASCollectionNode: SectionedNodeType {
    
    public func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        insertItems(at: paths)
    }
    
    public func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        deleteItems(at: paths)
    }
    
    public func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath) {
        moveItem(at: from, to: to)
    }
    
    public func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation) {
        reloadItems(at: paths)
    }
    
    public func insertSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        insertSections(indexSet(sections))
    }
    
    public func deleteSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        deleteSections(indexSet(sections))
    }
    
    public func moveSection(_ from: Int, to: Int) {
        moveSection(from, toSection: to)
    }
    
    public func reloadSections(_ sections: [Int], animationStyle: UITableView.RowAnimation) {
        reloadSections(indexSet(sections))
    }
}

public protocol SectionedNodeType {
    func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation)
    func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation)
    func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath)
    func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableView.RowAnimation)
    func insertSections(_ sections: [Int], animationStyle: UITableView.RowAnimation)
    func deleteSections(_ sections: [Int], animationStyle: UITableView.RowAnimation)
    func moveSection(_ from: Int, to: Int)
    func reloadSections(_ sections: [Int], animationStyle: UITableView.RowAnimation)
}

extension SectionedNodeType {
    
    public func batchUpdates<S>(_ changes: Changeset<S>, animationConfiguration: AnimationConfiguration) {
        deleteSections(changes.deletedSections, animationStyle: animationConfiguration.deleteAnimation)
        // Updated sections doesn't mean reload entire section, somebody needs to update the section view manually
        // otherwise all cells will be reloaded for nothing.
        // view.reloadSections(changes.updatedSections, animationStyle: rowAnimation)
        insertSections(changes.insertedSections, animationStyle: animationConfiguration.insertAnimation)
        for (from, to) in changes.movedSections {
            moveSection(from, to: to)
        }
        deleteItemsAtIndexPaths(
            changes.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
            animationStyle: animationConfiguration.deleteAnimation
        )
        insertItemsAtIndexPaths(
            changes.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
            animationStyle: animationConfiguration.insertAnimation
        )
        reloadItemsAtIndexPaths(
            changes.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
            animationStyle: animationConfiguration.reloadAnimation
        )
        for (from, to) in changes.movedItems {
            moveItemAtIndexPath(
                IndexPath(item: from.itemIndex, section: from.sectionIndex),
                to: IndexPath(item: to.itemIndex, section: to.sectionIndex)
            )
        }
    }
}
