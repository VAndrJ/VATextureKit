# VATextureKit


**[Texture](https://texturegroup.org/docs/getting-started.html)** library wrapper
<font size="1">with some additions.</font>

* [Installation](#installation)
* [Layout Specs](#layout-specs)
* [Modifiers](#modifiers)
* [Nodes](#nodes)


## Installation

### CocoaPods
Add the following to your Podfile:
```
pod 'VATextureKit'
```
In the project directory in Terminal.
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
            titleNode,
            subtitleNode,
        ]
    )
}
```

With `Column`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Column(spacing: 8) {
        titleNode
        subtitleNode
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
            titleNode,
            accessoryNode,
        ]
    )
}
```

With `Column`:

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Row(spacing: 4, main: .spaceBetween) {
        titleNode
        accessoryNode
    }
}
```

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

With `.background`:

```swift
imageNode
    .overlay(gradientNode)
```

</details>

// TODO: - Other specs

// TODO: - Complex layout example


## Modifiers

  * .sized
  * .flex
  * .maxConstrained
  * .minConstrained

// TODO: - Brief description

## Nodes

// TODO: - List

// TODO: - Brief description
