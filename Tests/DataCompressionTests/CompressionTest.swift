
import XCTest

@testable import DataCompression

class CompressionTest: XCTestCase
{
    func testEmptyString()
    {
        XCTAssertEqual("", pray(""))
    }
    
    func testMiscSmall()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s, pray(s), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers() 
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s, pray(s), "Fails with: \(s)")
        }
    }

    func testRandomDataChunks()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, comp(data), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataBlob()
    {
        let b = 1024 * 1024 * 15 // 15 MB
        let ints = [UInt32](repeating: 0, count: b / 4).map { _ in arc4random() }
        let data = Data(bytes: ints, count: b)
        XCTAssertEqual(data, comp(data), "Fails with random data large blob of 15 MB :(")
    }

    func comp(_ d: Data?) -> Data?
    {
        var tmp: Data? = d

        tmp = tmp?.deflate()
        tmp = tmp?.inflate()

        tmp = tmp?.zip()
        tmp = tmp?.unzip()

        tmp = tmp?.compress(withAlgorithm: .LZFSE)
        tmp = tmp?.decompress(withAlgorithm: .LZFSE)

        tmp = tmp?.compress(withAlgorithm: .LZ4)
        tmp = tmp?.decompress(withAlgorithm: .LZ4)

        tmp = tmp?.compress(withAlgorithm: .LZMA)
        tmp = tmp?.decompress(withAlgorithm: .LZMA)

        tmp = tmp?.compress(withAlgorithm: .ZLIB)
        tmp = tmp?.decompress(withAlgorithm: .ZLIB)

        return tmp
    }

    func pray(_ s: String) -> String?
    {
        let tmp: Data? = s.data(using: .utf8)

        guard let res = comp(tmp) else { return nil }

        return String(data: res, encoding: .utf8)
    }

}
