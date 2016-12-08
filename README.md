# SwiftDataCompression

#### A libcompression wrapper extension

Easy to use extension for the `Data` type. Supported compression algorithms are:

 * ZLIB deflate stream RFC-1950
 * ZLIB deflate raw RFC-1951
 * LZMA
 * LZFSE
 * LZ4

#### Usage example 

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

#### Install

Just drop the file in your project. This will be distributed with the swift-package-manager in the near future!
