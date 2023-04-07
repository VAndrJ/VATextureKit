# VATextureKit


**[Texture](https://texturegroup.org/docs/getting-started.html)** library wrapper with some additions.

* [Installation](#installation)
* [Layout Specs](#layout-specs)
* [Modifiers](#modifiers)
* [Nodes](#nodes)
* [Themes](#themes)
* [Rx property wrappers](#rx-property-wrappers)
* [Extensions](#extensions)


## Installation

### CocoaPods
Add the following to your Podfile:
```
pod 'VATextureKit'
```
In the project directory in Terminal:
```
pod install
```


## Layout Specs

The following `LayoutSpec` DSL components can be used to compose simple or very complex layouts.

| VATextureKit  | Texture                                 |
| ------------- |-----------------------------------------|
| Column        | ASStackLayoutSpec (vertical)            |
| Row           | ASStackLayoutSpec (horizontal)          |
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




<details open>
<summary>Column</summary>


With `ASStackLayoutSpec`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(
        direction: .vertical,
        spacing: 8,
        justifyContent: .start,
        alignItems: .start,
        children: [
            titleTextNode,
            subtitleTextNode,
        ]
    )
}
```

With `Column`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Column(spacing: 8) {
        titleTextNode
        subtitleTextNode
    }
}
```


</details>


<details>
<summary>Row</summary>


With `ASStackLayoutSpec`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(
        direction: .horizontal,
        spacing: 4,
        justifyContent: .spaceBetween,
        alignItems: .start,
        children: [
            titleTextNode,
            accessoryNode,
        ]
    )
}
```

With `Column`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Row(spacing: 4, main: .spaceBetween) {
        titleTextNode
        accessoryNode
    }
}
```


</details>


<details>
<summary>SafeArea</summary>


With `ASStackLayoutSpec` in `ASDisplayNode` that `automaticallyRelayoutOnSafeAreaChanges = true`: 

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
        insets: UIEdgeInsets(
            top: safeAreaInsets.top,
            left: safeAreaInsets.left,
            bottom: safeAreaInsets.bottom,
            right: safeAreaInsets.right
        ),
        child: ...
    )
}
```

With `SafeArea`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    SafeArea {
        ...
    }
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

With `.background`:

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

With `.background`:

```swift
imageNode.wrapped()
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
    return ASInsetLayoutSpec(
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

With `SafeArea`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    listNode
        .safe(in: self)
}
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

// TODO: - Complex layout example


## Modifiers

  * .sized
  * .flex
  * .maxConstrained
  * .minConstrained


<details>
<summary>.sized</summary>


Set `Node` size.

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


Set `Node` flex.

With `style`: 

```swift
titleTextNode.style.flexShrink = 0.1
titleTextNode.style.flexGrow = 1
```

With `.sized`:

```swift
titleTextNode
    .flex(shrink: 0.1, grow: 1)
```


</details>


<details>
<summary>.maxConstrained</summary>


Set `Node` max possible size.

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


Set `Node` min possible size.

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


// TODO: - List

// TODO: - Brief description


## Themes


// TODO: - Brief description


## Rx property wrappers


// TODO: - List

// TODO: - Brief description


## Extensions


// TODO: - Brief description
