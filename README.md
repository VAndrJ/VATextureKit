# VATextureKit


**[Texture](https://texturegroup.org/docs/getting-started.html)** library wrapper with some additions.

* [Installation](#installation)
* [Layout Specs](#layout-specs)
* [Modifiers](#modifiers)
* [Nodes](#nodes)
* [Containers](#containers)
* [Wrappers](#wrappers)
* [Animations](#animations)
* [Themes](#themes)
* [Extensions](#extensions)
* [Previews](#previews)
* [Property wrappers](#property-wrappers)
* [Experiments](#experiments)


## Installation

### CocoaPods
Add the following to your Podfile:
```
pod 'VATextureKit'
or
pod 'VATextureKitRx' // includes RxSwift and additinal wrappers.
```
In the project directory in the Terminal:
```
pod install
```


Or just try the example project:
```
pod try 'VATextureKit'
```

Minimum deployment target: **iOS 11**


## Layout Specs

The following `LayoutSpec` DSL components can be used to compose simple or very complex layouts.

| VATextureKit  | Texture                                 |
| ------------- |-----------------------------------------|
| Column        | ASStackLayoutSpec (vertical)            |
| Row           | ASStackLayoutSpec (horizontal)          |
| Stack         |                                         |
| SafeArea      | ASInsetLayoutSpec (with safeAreaInsets) |
| .padding      | ASInsetLayoutSpec                       |
| .wrapped      | ASWrapperLayoutSpec                     |
| .corner       | ASCornerLayoutSpec                      |
| .safe         | ASInsetLayoutSpec (with safeAreaInsets) |
| .centered     | ASCenterLayoutSpec                      |
| .ratio        | ASRatioLayoutSpec                       |
| .overlay      | ASOverlayLayoutSpec                     |
| .background   | ASBackgroundLayoutSpec                  |
| .relatively   | ASRelativeLayoutSpec                    |
| .absolutely   | ASAbsoluteLayoutSpec                    |




<details open>
<summary>Column</summary>


With `ASStackLayoutSpec`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASStackLayoutSpec(
        direction: .vertical,
        spacing: 8,
        justifyContent: .start,
        alignItems: .start,
        children: [
            firstRectangleNode,
            secondRectangleNode,
        ]
    )
}
```


With `Column`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Column(spacing: 8) {
        firstRectangleNode
        secondRectangleNode
    }
}
```


Example:


![Column example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/column_example.png)


</details>


<details>
<summary>Row</summary>


With `ASStackLayoutSpec`: 

```swift
ASStackLayoutSpec(
    direction: .horizontal,
    spacing: 4,
    justifyContent: .spaceBetween,
    alignItems: .start,
    children: [
        firstRectangleNode,
        secondRectangleNode,
    ]
)
```


With `Row`:

```swift
Row(spacing: 4, main: .spaceBetween) {
    firstRectangleNode
    secondRectangleNode
}
```


Example:


![Column example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/row_example.png)


</details>


<details>
<summary>Stack</summary>


`Stack`:


```swift
Stack {
    firstRectangleNode
    secondRectangleNode
}
```


Example:


![Column example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/stack_example.png)


</details>


<details>
<summary>SafeArea</summary>


With `ASStackLayoutSpec` in `ASDisplayNode` that `automaticallyRelayoutOnSafeAreaChanges = true`: 

```swift
ASInsetLayoutSpec(
    insets: UIEdgeInsets(
        top: safeAreaInsets.top,
        left: safeAreaInsets.left,
        bottom: safeAreaInsets.bottom,
        right: safeAreaInsets.right
    ),
    child: ...
)
```


With `SafeArea`:

```swift
SafeArea {
    ...
}
```


</details>


<details>
<summary>.padding</summary>


With `ASInsetLayoutSpec`: 

```swift
ASInsetLayoutSpec(
    insets: UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8
    ),
    child: titleTextNode
)
```


With `.padding`:

```swift
titleTextNode
    .padding(.all(8))
```


</details>


<details>
<summary>.wrapped</summary>


With `ASWrapperLayoutSpec`: 

```swift
ASWrapperLayoutSpec(layoutElement: imageNode)
```


With `.wrapped`:

```swift
imageNode
    .wrapped()
```


</details>


<details>
<summary>.corner</summary>


With `ASWrapperLayoutSpec`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let spec = ASCornerLayoutSpec(
        child: imageNode,
        corner: badgeNode,
        location: .topRight
    )
    spec.offset = CGPoint(x: 4, y: 2)
    spec.wrapsCorner = false
    return spec
}
```


With `.corner`:

```swift
imageNode
    .corner(badgeNode, offset: CGPoint(x: 4, y: 2))
```


</details>


<details>
<summary>.safe</summary>


With `ASStackLayoutSpec` in `ASDisplayNode` that `automaticallyRelayoutOnSafeAreaChanges = true`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASInsetLayoutSpec(
        insets: UIEdgeInsets(
            top: safeAreaInsets.top,
            left: safeAreaInsets.left,
            bottom: safeAreaInsets.bottom,
            right: safeAreaInsets.right
        ),
        child: listNode
    )
}
```


With `.safe`:

```swift
listNode
    .safe(in: self)
```


</details>


<details>
<summary>.centered</summary>


With `ASCenterLayoutSpec`: 

```swift
ASCenterLayoutSpec(
    centeringOptions: .XY,
    sizingOptions: .minimumXY,
    child: buttonNode
)
```


With `.centered`:

```swift
buttonNode
    .centered()
```


</details>


<details>
<summary>.ratio</summary>


With `ASRatioLayoutSpec`: 

```swift
ASRatioLayoutSpec(
    ratio: 2 / 3,
    child: imageNode
)
```


With `.ratio`:

```swift
imageNode
    .ratio(2 / 3)
```


</details>


</details>

<details>
<summary>.overlay</summary>


With `ASOverlayLayoutSpec`: 

```swift
ASOverlayLayoutSpec(
    child: imageNode,
    overlay: gradientNode
)
```


With `.overlay`:

```swift
imageNode
    .overlay(gradientNode)
```


</details>


<details>
<summary>.background</summary>


With `ASOverlayLayoutSpec`: 

```swift
ASBackgroundLayoutSpec(
    child: gradientNode,
    background: imageNode
)
```


With `.background`:

```swift
imageNode
    .background(gradientNode)
```


</details>


<details>
<summary>.relatively</summary>


With `ASOverlayLayoutSpec`: 

```swift
ASRelativeLayoutSpec(
    horizontalPosition: .start,
    verticalPosition: .end,
    sizingOption: .minimumSize,
    child: buttonNode
)
```


With `.relatively`:

```swift
buttonNode
    .relatively(horizontal: .start, vertical: .end)
```


</details>


<details>
<summary>.absolutely</summary>


With `ASAbsoluteLayoutSpec`: 

```swift
buttonNode.style.preferredSize = frame.size
buttonNode.style.layoutPosition = frame.origin
return ASAbsoluteLayoutSpec(
    sizing: .sizeToFit,
    children: [buttonNode]
)
```


With `.absolutely`:

```swift
buttonNode
    .absolutely(frame: .frame, sizing: .sizeToFit)
```


</details>


<details open>
<summary>More complex layout example</summary>


![Cell layout](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/cell_layout_example.png)


With `VATextureKit`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Column(cross: .stretch) {
        Row(main: .spaceBetween) {
            Row(spacing: 8, cross: .center) {
                testNameTextNode
                testInfoButtonNode
            }
            testStatusTextNode
        }
        titleTextNode
            .padding(.top(8))
        resultTextNode
            .padding(.top(32))
            .centered(.X)
        resultUnitsTextNode
            .centered(.X)
        referenceResultBarNode
            .padding(.vertical(24))
        Row(spacing: 16, cross: .center) {
            Column(spacing: 8) {
                Row(spacing: 8) {
                    resultBadgeImageNode
                    resultDescriptionTextNode
                }
                referenceValuesTextNode
            }
            accessoryImageNode
        }
    }
    .padding(.all(16))
}
```


With raw `Texture`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASInsetLayoutSpec(
        insets: UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        ),
        child: ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                ASStackLayoutSpec(
                    direction: .horizontal,
                    spacing: 0,
                    justifyContent: .spaceBetween,
                    alignItems: .start,
                    children: [
                        ASStackLayoutSpec(
                            direction: .horizontal,
                            spacing: 8,
                            justifyContent: .start,
                            alignItems: .center,
                            children: [
                                testNameTextNode,
                                testInfoButtonNode,
                            ]
                        ),
                        testStatusTextNode,
                    ]
                ),
                ASInsetLayoutSpec(
                    insets: UIEdgeInsets(
                        top: 8,
                        left: 0,
                        bottom: 0,
                        right: 0
                    ),
                    child: titleTextNode
                ),
                ASCenterLayoutSpec(
                    centeringOptions: .X,
                    sizingOptions: .minimumXY,
                    child: ASInsetLayoutSpec(
                        insets: UIEdgeInsets(
                            top: 32,
                            left: 0,
                            bottom: 0,
                            right: 0
                        ),
                        child: resultTextNode
                    )
                ),
                ASCenterLayoutSpec(
                    centeringOptions: .X,
                    sizingOptions: .minimumXY,
                    child: resultUnitsTextNode
                ),
                ASInsetLayoutSpec(
                    insets: UIEdgeInsets(
                        top: 24,
                        left: 0,
                        bottom: 24,
                        right: 0
                    ),
                    child: referenceResultBarNode
                ),
                ASStackLayoutSpec(
                    direction: .horizontal,
                    spacing: 0,
                    justifyContent: .start,
                    alignItems: .center,
                    children: [
                        ASStackLayoutSpec(
                            direction: .vertical,
                            spacing: 8,
                            justifyContent: .start,
                            alignItems: .start,
                            children: [
                                ASStackLayoutSpec(
                                    direction: .horizontal,
                                    spacing: 8,
                                    justifyContent: .start,
                                    alignItems: .start,
                                    children: [
                                        resultBadgeImageNode,
                                        resultDescriptionTextNode,
                                    ]
                                ),
                                referenceValuesTextNode,
                            ]
                        ),
                        accessoryImageNode,
                    ]
                ),
            ]
        )
    )
}
```


</details>


## Modifiers


<details>
<summary>.sized</summary>


Set `Node`'s size.


With `style`: 

```swift
imageNode.style.width = ASDimension(unit: .points, value: 320)
imageNode.style.height = ASDimension(unit: .points, value: 480)
```


With `.sized`:

```swift
imageNode
    .sized(width: 320, height: 480)
```


</details>


<details>
<summary>.flex</summary>


Set `Node`'s flex.


With `style`: 

```swift
titleTextNode.style.flexShrink = 0.1
titleTextNode.style.flexGrow = 1
```


With `.flex`:

```swift
titleTextNode
    .flex(shrink: 0.1, grow: 1)
```


</details>


<details>
<summary>.maxConstrained</summary>


Set `Node`'s max possible size.


With `style`: 

```swift
titleTextNode.style.maxWidth = ASDimension(unit: .points, value: 320)
titleTextNode.style.maxHeight = ASDimension(unit: .points, value: 100)
```


With `.maxConstrained`:

```swift
titleTextNode
    .maxConstrained(width: 320, height: 480)
```


</details>


<details>
<summary>.minConstrained</summary>


Set `Node`'s min possible size.


With `style`: 

```swift
titleTextNode.style.minWidth = ASDimension(unit: .points, value: 100)
titleTextNode.style.minHeight = ASDimension(unit: .points, value: 50)
```


With `.minConstrained`:

```swift
titleTextNode
    .minConstrained(width: 100, height: 50)
```


</details>


## Nodes


<details>
<summary>VADisplayNode</summary>


A subclass of `ASDisplayNode` that automatically manages subnodes and handles theme updates.


</details>


<details>
<summary>VATextNode</summary>


A subclass of `ASTextNode` that handles content size and theme updates. Have default text styles. 


</details>


<details>
<summary>VAButtonNode</summary>


A subclass of `ASButtonNode` with `onTap` closure. 


</details>


<details>
<summary>VACellNode</summary>


A subclass of `ASCellNode` that automatically manages subnodes and handles theme updates.


</details>


<details>
<summary>VAImageNode</summary>


A subclass of `ASImageNode` with parametrized initializer.


</details>


<details>
<summary>VASpacerNode</summary>


A subclass of `ASDisplayNode` to fill space in `Row / Column`.


</details>


<details>
<summary>VASafeAreaDisplayNode</summary>


A subclass of `VADisplayNode` that automatically relayout on safe area changes.


</details>


<details>
<summary>VABaseGradientNode</summary>


A subclass of `ASDisplayNode` with `CAGradientLayer` root layer.


</details>


<details>
<summary>VALinearGradientNode</summary>


A subclass of `VABaseGradientNode` with parametrized initializer to simplify linear gradient creation.


</details>


<details>
<summary>VARadialGradientNode</summary>


A subclass of `VABaseGradientNode` with parametrized initializer to simplify radial gradient creation.


</details>


<details>
<summary>VAShapeNode</summary>


A subclass of `ASDisplayNode` with `CAShapeLayer` root layer.


</details>


<details>
<summary>VAEmitterNode</summary>


A subclass of `ASDisplayNode` with `CAEmitterLayer` support.


</details>


<details>
<summary>VATypingTextNode</summary>


A subclass of `VATextNode` with typing animation.


Example:


![Typing example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/typing_example.gif)


</details>


<details>
<summary>VAReadMoreTextNode</summary>


A subclass of `VATextNode` with "Read more" truncation in easy way.


Code:


```
lazy var readMoreTextNode = VAReadMoreTextNode(
    text: .loremText,
    maximumNumberOfLines: 2,
    readMore: .init(
        text: "Read more",
        fontStyle: .headline,
        colorGetter: { $0.systemBlue }
    )
)
```


Example:


![Read more example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/read_more_example.gif)


</details>


<details>
<summary>VACountingTextNode</summary>


A subclass of `VATextNode` with counting initation.


Code:


```
countingTextNode.updateCount(to: Int.random(in: 0...1000))
```


Example:

![Link text node](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/counting_text_example.gif)


</details>


<details>
<summary>VAShimmerNode</summary>


A subclass of `VADisplayNode` with shimmering animation.


Example:


![Shimmer example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/shimmer_example.gif)


</details>


## Containers


<details>
<summary>VAListNode</summary>


*Part of `VATextureKitRx`


A subclass of `ASCollectionNode` to use it in declarative way.


Example:


![List example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/list_example.gif)


![Dynamic heights layout example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/dynamic_heights_example.gif)


![Spec layout example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/spec_layout_example.gif)


</details>


<details>
<summary>VATableListNode</summary>


*Part of `VATextureKitRx`


A subclass of `ASTableNode` to use it in declarative way.


</details>


<details>
<summary>VAPagerNode</summary>


*Part of `VATextureKitRx`


A subclass of `ASPagerNode` to use it in declarative way. 
Some crutches to mimic circular scrolling.


Example:


![Pager node example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/pager_example.gif)


</details>


<details>
<summary>VAViewController</summary>


A subclass of `ASDKViewController` that handles theme updates.


</details>


<details>
<summary>VANavigationController</summary>


A subclass of `ASDKNavigationController` that handles theme updates and content size changes.


</details>


<details>
<summary>VATabBarController</summary>


A subclass of `ASTabBarController` that handles theme updates.


</details>


<details>
<summary>VAWindow</summary>


A subclass of `VAWindow` to handle theme updates and content size changes. Provides app context.


</details>


<details>
<summary>VAContainerCellNode</summary>


To wrap any node with Cell Node.


</details>


## Wrappers


<details>
<summary>VAViewWrapperNode</summary>


Container to use `UIView` with nodes.


</details>


<details>
<summary>VANodeWrapperView</summary>


Container to use node with views.


</details>


<details>
<summary>VASizedViewWrapperNode</summary>


Container to use `UIView` with nodes and inheriting its size.


</details>


## Animations


<details>
<summary>Layout transition animations</summary>


Layout transition animations in easy way. Just write:

```
override func animateLayoutTransition(_ context: ASContextTransitioning) {
    animateLayoutTransition(context: context)
}
```


Example:


![Layout transition example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/layout_transition_example.gif)


</details>


<details>
<summary>Node animations</summary>


Node animations in easy way. 


Example:

```
pulseNode.animate(.scale(values: [1, 1.1, 0.9, 1.2, 0.8, 1.1, 0.9, 1]), duration: 1)
```


Result:


![Layout transition example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/pulse_animation_example.gif)


More examples:


![Layout transition example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/animations_example.gif)


</details>


## Themes


Themes support in easy way. Default light / dark or custom init.


## Extensions


<details open>
<summary>ASDimension</summary>


Init support.

With raw `Texture`: 
```
style.height = ASDimension(unit: .auto, value: 0)
style.height = ASDimension(unit: .points, value: height)
style.height = ASDimension(unit: .fraction, value: 0.3)
```


With `VATextureKit`:
```
style.height = .auto
style.height = .points(height)
style.height = .fraction(0.3)
style.height = .fraction(percent: 30)
```


</details>


<details>
<summary>CGSize</summary>


Math:

```
CGSize(width: 2, height: 2) * 2 = CGSize(width: 4, height: 4)

CGSize(width: 2, height: 2) + 1 = CGSize(width: 3, height: 3)
```


Initializer:

```
CGSize(same: 16) == CGSize(width: 16, height: 16)
```


</details>


<details>
<summary>UIEdgeInsets</summary>


Variables:

```
/// (top, left)
origin: CGPoint 

/// top + bottom
vertical: CGFloat

/// left + right
horizontal: CGFloat
```


Initializer:

```
UIEdgeInsets(all: 16) == UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

UIEdgeInsets(vertical: 16) == UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

UIEdgeInsets(horizontal: 16) == UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
UIEdgeInsets(vertical: 4, horizontal: 8) == UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
```


</details>


## Previews


Node preview in easy way with support function:


```swift
sRepresentation(layout:)
```

![Preview example](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/preview_example.png)


## Property wrappers


*Part of `VATextureKitRx`


* Obs
  * Relay(value:) (BehaviorRelay)
  * Relay() (PublishRelay)


With these wrappers, the code becomes more concise.


<details open>
<summary>BehaviorRelay</summary>


```
var someObs: Observable<String> { someRelay.asObservable() }

private let someRelay = BehaviorRelay<String>(value: "value")
...
someRelay.accept("value1")
```


becomes


```
@Obs.Relay(value: "value")
var someObs: Observable<String>
...
_someObs.rx.accept("value1")
```


</details>


<details>
<summary>PublishRelay</summary>


```
var someObs: Observable<String> { someRelay.asObservable() }

private let someRelay = PublishRelay<String>()
```


becomes


```
@Obs.Relay()
var someObs: Observable<String>
```


</details>


## Experiments


<details open>
<summary>VASlidingTabBarNode</summary>


![Sliding tab bar](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/sliding_tab_bar_example.gif)


</details>


<details open>
<summary>VAEmitterNode</summary>


![Confetti emitter](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/confetti_emitter_example.gif)
 ![Text emitter](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/text_emitter_example.gif)


</details>


<details open>
<summary>VALinkTextNode</summary>


![Link text node](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/link_text_example.gif)


</details>
