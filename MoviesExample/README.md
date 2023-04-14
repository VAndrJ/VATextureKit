# Movies app example using VATextureKit

  * [Run](#run)
  * [How its look](#how-its-look)

## Run


Steps to run:


* In the Terminal in the project folder:
```
pod install
```

```
xed .
```

* open `Config.xcconfig` and replace `XXXXXXXXXXXXXXXXXXXXXXXXXXX` with your TMDB API token.

* run

* explore UI examples


## How its look


![Movie app example 1](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/movie_app_example_ui.gif)


Cell layout code. 


* Example 1:


```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Row(spacing: 16) {
        imageNode
        Column(spacing: 4, cross: .stretch) {
            titleTextNode
            descriptionTextNode
        }
        .flex(shrink: 0.1, grow: 1)
    }
    .padding(.all(16))
}
```

Result:


![Cell layout result example 1](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/cell_layout_example_1.png)


* Example 2:


```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    Column {
        Row(spacing: 16, cross: .center) {
            imageNode
            titleTextNode
        }
        .padding(.vertical(6), .horizontal(16))
        separatorNode
            .padding(.left(60), .right(16))
    }
}
```


Result:


![Cell layout result example 2](https://raw.githubusercontent.com/VAndrJ/VATextureKit/master/Resources/cell_layout_example_2.png)
