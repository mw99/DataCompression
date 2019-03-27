
import XCTest

@testable import DataCompression

class CompressionTest: XCTestCase
{
    func testEmptyString()
    {
        XCTAssertEqual("", pray(""))
    }

    func testEmptyData()
    {
        XCTAssertEqual(Data(), comp(Data()))
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
        XCTAssertNotNil(tmp, "deflate() failed")
        tmp = tmp?.inflate()
        XCTAssertNotNil(tmp, "inflate() failed")

        tmp = tmp?.zip()
        XCTAssertNotNil(tmp, "zip() failed")
        tmp = tmp?.unzip()
        XCTAssertNotNil(tmp, "unzip() failed")

        tmp = tmp?.gzip()
        XCTAssertNotNil(tmp, "gzip() failed")
        tmp = tmp?.gunzip()
        XCTAssertNotNil(tmp, "gunzip() failed")

        tmp = tmp?.compress(withAlgorithm: .lzfse)
        XCTAssertNotNil(tmp, "compress .lzfse() failed")
        tmp = tmp?.decompress(withAlgorithm: .lzfse)
        XCTAssertNotNil(tmp, "decompress .lzfse() failed")

        tmp = tmp?.compress(withAlgorithm: .lz4)
        XCTAssertNotNil(tmp, "compress .lz4() failed")
        tmp = tmp?.decompress(withAlgorithm: .lz4)
        XCTAssertNotNil(tmp, "decompress .lz4() failed")

        tmp = tmp?.compress(withAlgorithm: .lzma)
        XCTAssertNotNil(tmp, "compress .lzma() failed")
        tmp = tmp?.decompress(withAlgorithm: .lzma)
        XCTAssertNotNil(tmp, "decompress .lzma() failed")

        return tmp
    }

    func pray(_ s: String) -> String?
    {
        let tmp: Data? = s.data(using: .utf8)

        guard let res = comp(tmp) else { return nil }

        return String(data: res, encoding: .utf8)
    }

    func testAdler32()
    {
        var adler = Adler32()
        XCTAssertEqual(adler.checksum, 0x1)
        adler.advance(withChunk: "The quick brown ".data(using: .ascii)!)
        adler.advance(withChunk: "fox jumps over ".data(using: .ascii)!)
        adler.advance(withChunk: "the lazy dog.".data(using: .ascii)!)
        XCTAssertEqual(adler.checksum, 0x6be41008)
    }

    func testCrc32()
    {
        var crc = Crc32()
        XCTAssertEqual(crc.checksum, 0x0)
        crc.advance(withChunk: "The quick brown ".data(using: .ascii)!)
        crc.advance(withChunk: "fox jumps over ".data(using: .ascii)!)
        crc.advance(withChunk: "the lazy dog.".data(using: .ascii)!)
        XCTAssertEqual(crc.checksum, 0x519025e9)
    }
}
