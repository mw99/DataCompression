# DataCompression

### A libcompression wrapper extension for the `Data` type

#### Supported compression algorithms are:

 * GZIP format (.gz files) [RFC-1952](https://www.ietf.org/rfc/rfc1952.txt)
 * ZLIB deflate stream [RFC-1950](https://www.ietf.org/rfc/rfc1950.txt)
 * ZLIB deflate raw [RFC-1951](https://www.ietf.org/rfc/rfc1951.txt)
 * [LZMA](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm)
 * [LZFSE](https://github.com/lzfse/lzfse)
 * [LZ4](https://en.wikipedia.org/wiki/LZ4_(compression_algorithm))

#### Requirements
 * iOS deployment target **>= 9.0**
 * macOS deployment target **>= 10.11**
 * tvOS deployment target **>= 9.0**
 * watchOS deployment target **>= 2.0**


#### Swift version support
| Library Version | Swift Version |
|-----------------|---------------|
| 3.5.0           | 5.0           |
| 3.1.0           | 4.2           |
| 3.0.0           | 3.0 -> 4.1    |
| 2.0.1           | < 3.0         |


## Usage example

### Try all algorithms and compare the compression ratio 
```swift
let raw: Data! = String(repeating: "There is no place like 127.0.0.1", count: 25).data(using: .utf8)

print("raw   =>   \(raw.count) bytes")

for algo: Data.CompressionAlgorithm in [.zlib, .lzfse, .lz4, .lzma] {
    let compressedData: Data! = raw.compress(withAlgorithm: algo)

    let ratio = Double(raw.count) / Double(compressedData.count)
    print("\(algo)   =>   \(compressedData.count) bytes, ratio: \(ratio)")
    
    assert(compressedData.decompress(withAlgorithm: algo)! == raw)
}
```

Will print something like:
```
raw    =>   800 bytes
zlib   =>    40 bytes, ratio:  20.00
lzfse  =>    69 bytes, ratio:  11.59
lz4    =>   181 bytes, ratio:   4.42
lzma   =>   100 bytes, ratio:   8.00
```

### Container formats


##### The famous zlib deflate algorithm ([RFC-1951](https://www.ietf.org/rfc/rfc1951.txt)) can also be used with the shortcuts `.deflate()` and `.inflate()`
```
let data: Data! = "https://www.ietf.org/rfc/rfc1951.txt".data(using: .utf8)
let deflated: Data! = data.deflate()
let inflated: Data? = deflated?.inflate()
assert(data == inflated)
```

##### Data in gzip format ([RFC-1952](https://www.ietf.org/rfc/rfc1952.txt)) can be handled with `.gzip()` and `.gunzip()`
```
let data: Data! = "https://www.ietf.org/rfc/rfc1952.txt".data(using: .utf8)
let gzipped: Data! = data.gzip()
let gunzipped: Data? = gzipped.gunzip()
assert(data == gunzipped)
```
*Note: Compressed data in gzip format will always be 18 bytes larger than raw deflated data and will append/perform a crc32 checksum based data integrity test .*

##### Data in zip format ([RFC-1950](https://www.ietf.org/rfc/rfc1950.txt)) can be handled with `.zip()` and `.unzip()`
```
let data: Data! = "https://www.ietf.org/rfc/rfc1950.txt".data(using: .utf8)
let zipped: Data! = data.zip()
let unzipped: Data? = zipped.unzip()
assert(data == unzipped)
```
*Note: Compressed data in zip format will always be 6 bytes larger than raw deflated data and will append/perform a adler32 checksum based data integrity test .*


### Compress a file on the command line and decompress it in Swift
The easiest way is using the already installed **gzip** command line tool. Assuming you have a file called **file.txt**, after calling
```bash
gzip -9 file.txt
```
the file should have been compressed to **file.txt.gz**. You can now load and uncompress the contents of your file with:
```
let compressedData = try? Data(contentsOf: URL(fileURLWithPath: "/path/to/your/file.txt.gz"))

if let uncompressedData = compressedData?.gunzip() {
    print(String(data: uncompressedData, encoding: .utf8) ?? "Can't decode UTF-8")
}
```

### Checksum extensions
Unrelated to compression but for convenience **Crc32** and **Adler32** methods are also exposed on the `Data` type which may come in handy.
```
let classicExample = "The quick brown fox jumps over the lazy dog".data(using: .utf8)!
let crc32    = classicExample.crc32()
let adler32  = classicExample.adler32()
print("crc32: \(crc32), adler32: \(adler32)")
```
Will print:
```
crc32: 414fa339, adler32: 5bdc0fda
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


#### Carthage

**Note:** DataCompression versions < 3.3.0 are not compatible with carthage. That means Swift 5 only.

To integrate DataCompression into your Xcode project using Carthage, add it as a dependency to your `Cartfile`. Just add:
```
github "mw99/DataCompression"
```

You will then have to add the framework paths in the `carthage copy-frameworks` run script phase of your Xcode project.
The paths may differ depending on you have setup your project in relation to Carthage.

##### Input:
```
$(SRCROOT)/Carthage/Build/iOS/DataCompression.framework
```
##### Output:
```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/DataCompression.framework
```

You then will need to add `import DataCompression` at the top of your swift source files to use the extension.


#### Swift Package Manager

To integrate DataCompression into your Xcode project using the swift package manager, add it as a dependency to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "<your_package_name>",
    dependencies: [
        .Package(url: "https://github.com/mw99/DataCompression.git", majorVersion: 3)
    ]
)
```

You then will need to add `import DataCompression` at the top of your swift source files to use the extension.

The next time you run `swift build`, the new dependencies will be resolved. Since the swift package manager still does not allow packages to define their minimum deployment target, you will have to define these on the command line. I expect this to be fixed in a future release of the swift package manager.

```bash
$ swift build -Xswiftc -target -Xswiftc x86_64-apple-macosx10.11
```


#### Or just copy the file into your project

You only need one file located at `Sources/DataCompression.swift`. Drag and drop it into the Xcode project navigator.


## Change log / Upgrading guide


##### Version `3.4.0` to `3.5.0`
- Fix that prevents a bug in Apples lzfse compressor when working with large chunks of data.

##### Version `3.3.0` to `3.4.0`
- Swift 5 release had further deprecation warnings than in the Swift 5 beta. Fixed.

##### Version `3.2.0` to `3.3.0`
- Added support for Carthage

##### Version `3.1.0` to `3.2.0`
- Podspec swift version set to **5.0**
- Library file structure updated to fit the new swift package manager layout

##### Version `3.0.0` to `3.1.0`
- Podspec swift version set to **4.2**

##### Version `2.0.X` to `3.0.0`

- The encoded data in zip format is not copied anymore, which should improve performance.
- Checksum validation is now always performed with libz and way faster.
- The `skipCheckSumValidation:` parameter of `.unzip()` was removed.
- Items of the algorithm enum type are now Swift like lowercase, e.g. `.LZMA` → `.lzma`


## License


##### Apache License, Version 2.0

##### Copyright 2016, Markus Wanke

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

