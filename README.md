# DataCompression

### A libcompression wrapper extension for the `Data` type

##### Supported compression algorithms are:

 * ZLIB deflate stream [RFC-1950](https://www.ietf.org/rfc/rfc1950.txt)
 * ZLIB deflate raw [RFC-1951](https://www.ietf.org/rfc/rfc1951.txt)
 * [LZMA](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm)
 * [LZFSE](https://github.com/lzfse/lzfse)
 * [LZ4](https://en.wikipedia.org/wiki/LZ4_(compression_algorithm))

##### Requirements
 * iOS deployment target >= **9.0**
 * macOS deployment target >= **10.11**
 * tvOS deployment target >= **9.0**
 * watchOS deployment target >= **2.0**


## Usage example

```swift
    let s = "A string that really needs to loose some weight..."
    var res: Data? = s.data(using: .utf8)

    res = res?.deflate()
    res = res?.inflate()

    res = res?.zip()
    res = res?.unzip()

    res = res?.compress(withAlgorithm: .LZFSE)
    res = res?.decompress(withAlgorithm: .LZFSE)

    res = res?.compress(withAlgorithm: .LZ4)
    res = res?.decompress(withAlgorithm: .LZ4)

    res = res?.compress(withAlgorithm: .LZMA)
    res = res?.decompress(withAlgorithm: .LZMA)

    res = res?.compress(withAlgorithm: .ZLIB)
    res = res?.decompress(withAlgorithm: .ZLIB)

    assert(res != nil)
    let t = String(data: res!, encoding: .utf8)
    assert(s == t)
```

## Install

#### Cocoa Pods

To integrate DataCompression into your Xcode project using CocoaPods, add it to your `Podfile`:

```ruby
target '<your_target_name>' do
    pod 'DataCompression'
end
```

Then, run the following command:

```bash
$ pod install
```

You then will need to add `import DataCompression` at the top of your swift source files to use the extension.


#### Swift Package Manager

To integrate DataCompression into your Xcode project using the swift package manager, add it as a dependency to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "<your_package_name>",
    dependencies: [
        .Package(url: "https://github.com/mw99/DataCompression.git", majorVersion: 2)
    ]
)
```

You then will need to add `import DataCompression` at the top of your swift source files to use the extension.

The next time you run `swift build`, the new dependencies will be resolved. Since the swift package manager still does not allow packages to define their minimum deployment target, you will have to define these on the command line. I expect this to be fixed in a future release of the swift package manager.

```bash
$ swift build -Xswiftc -target -Xswiftc x86_64-apple-macosx10.11
```


#### Or just copy the file into your project

You only need one file located in `Sources/DataCompression.swift`. Drag and drop it into the Xcode project navigator.



