
import XCTest

@testable import DataCompression


extension Data
{
    func deflate_inflate() -> Data? { return c_deflate()?.c_inflate() }
    func zip_unzip()       -> Data? { return c_zip()?.c_unzip() }
    func gzip_gunzip()     -> Data? { return c_gzip()?.c_gunzip() }
    func lz4_delz4()       -> Data? { return c_lz4()?.c_delz4() }
    func lzma_delzma()     -> Data? { return c_lzma()?.c_delzma() }
    func lzfse_delzfse()   -> Data? { return c_lzfse()?.c_delzfse() }


    func c_deflate()  -> Data? { let res: Data? = self.deflate(); XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_inflate()  -> Data? { let res: Data? = self.inflate(); XCTAssertNotNil(res, "\(#function) failed"); return res }

    func c_zip()      -> Data? { let res: Data? = self.zip();     XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_unzip()    -> Data? { let res: Data? = self.unzip(skipCheckSumValidation: false);   XCTAssertNotNil(res, "\(#function) failed"); return res }

    func c_gzip()     -> Data? { let res: Data? = self.gzip();     XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_gunzip()   -> Data? { let res: Data? = self.gunzip();   XCTAssertNotNil(res, "\(#function) failed"); return res }

    func c_lz4()      -> Data? { let res: Data? = self.compress(withAlgorithm: .lz4);     XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_delz4()    -> Data? { let res: Data? = self.decompress(withAlgorithm: .lz4);   XCTAssertNotNil(res, "\(#function) failed"); return res }

    func c_lzma()     -> Data? { let res: Data? = self.compress(withAlgorithm: .lzma);    XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_delzma()   -> Data? { let res: Data? = self.decompress(withAlgorithm: .lzma);  XCTAssertNotNil(res, "\(#function) failed"); return res }

    func c_lzfse()    -> Data? { let res: Data? = self.compress(withAlgorithm: .lzfse);   XCTAssertNotNil(res, "\(#function) failed"); return res }
    func c_delzfse()  -> Data? { let res: Data? = self.decompress(withAlgorithm: .lzfse); XCTAssertNotNil(res, "\(#function) failed"); return res }
}


extension String
{
    func deflate_inflate() -> Data? { return data(using: .ascii)?.deflate_inflate() }
    func zip_unzip()       -> Data? { return data(using: .ascii)?.zip_unzip() }
    func gzip_gunzip()     -> Data? { return data(using: .ascii)?.gzip_gunzip() }
    func lz4_delz4()       -> Data? { return data(using: .ascii)?.lz4_delz4() }
    func lzma_delzma()     -> Data? { return data(using: .ascii)?.lzma_delzma() }
    func lzfse_delzfse()   -> Data? { return data(using: .ascii)?.lzfse_delzfse() }
}


class CompressionTest: XCTestCase
{
    static var blob16mb: Data!

    override class func setUp()
    {
        super.setUp()
        let b = 1024 * 1024 * 16 // 16 MB
        let ints = [UInt32](repeating: 0, count: b / 4).map { _ in arc4random() }
        self.blob16mb = Data(bytes: ints, count: b)
    }

    func testEmptyString()
    {
        XCTAssertEqual(Data(), "".deflate_inflate())
        XCTAssertEqual(Data(), "".zip_unzip())
        XCTAssertEqual(Data(), "".gzip_gunzip())
        XCTAssertEqual(Data(), "".lz4_delz4())
        XCTAssertEqual(Data(), "".lzma_delzma())
        XCTAssertEqual(Data(), "".lzfse_delzfse())
    }

    func testEmptyData()
    {
        XCTAssertEqual(Data(), Data().deflate_inflate())
        XCTAssertEqual(Data(), Data().zip_unzip())
        XCTAssertEqual(Data(), Data().gzip_gunzip())
        XCTAssertEqual(Data(), Data().lz4_delz4())
        XCTAssertEqual(Data(), Data().lzma_delzma())
        XCTAssertEqual(Data(), Data().lzfse_delzfse())
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
    
    func testMiscSmall_deflate_inflate()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.deflate_inflate(), "Fails with: \(s)")
        }
    }

    func testMiscSmall_zip_unzip()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.zip_unzip(), "Fails with: \(s)")
        }
    }
    
    func testMiscSmall_gzip_gunzip()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.gzip_gunzip(), "Fails with: \(s)")
        }
    }

    func testMiscSmall_lz4_delz4()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lz4_delz4(), "Fails with: \(s)")
        }
    }

    func testMiscSmall_lzma_delzma()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lzma_delzma(), "Fails with: \(s)")
        }
    }

    func testMiscSmall_lzfse_delzfse()
    {
        for i in 1...500 {
            let s = String(repeating: "a", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lzfse_delzfse(), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers_deflate_inflate()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.deflate_inflate(), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers_zip_unzip()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.zip_unzip(), "Fails with: \(s)")
        }
    }
    
    func testAsciiNumbers_gzip_gunzip()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.gzip_gunzip(), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers_lz4_delz4()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lz4_delz4(), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers_lzma_delzma()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lzma_delzma(), "Fails with: \(s)")
        }
    }

    func testAsciiNumbers_lzfse_delzfse()
    {
        for i in 1...500 {
            let r = sqrt(Double(i)) / .pi 
            let s = String(repeating: "\(r)", count: i)
            XCTAssertEqual(s.data(using: .ascii), s.lzfse_delzfse(), "Fails with: \(s)")
        }
    }


    func testRandomDataChunks_deflate_inflate()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.deflate_inflate(), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataChunks_zip_unzip()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.zip_unzip(), "Fails with random data (\(data.count) bytes) :(")
        }
    }
    
    func testRandomDataChunks_gzip_gunzip()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.gzip_gunzip(), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataChunks_lz4_delz4()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.lz4_delz4(), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataChunks_lzma_delzma()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.lzma_delzma(), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataChunks_lzfse_delzfse()
    {
        for i in 1...500 {
            let ints = [UInt32](repeating: 0, count: 1 + (i / 4)).map { _ in arc4random() }
            let data = Data(bytes: ints, count: i)
            XCTAssertEqual(data, data.lzfse_delzfse(), "Fails with random data (\(data.count) bytes) :(")
        }
    }

    func testRandomDataBlob_16MB_deflate_inflate()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.deflate_inflate())
    }

    func testRandomDataBlob_16MB_zip_unzip()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.zip_unzip())
    }

    func testRandomDataBlob_16MB_gzip_gunzip()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.gzip_gunzip())
    }

    func testRandomDataBlob_16MB_lz4_delz4()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.lz4_delz4())
    }

    func testRandomDataBlob_16MB_lzma_delzma()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.lzma_delzma())
    }

    func testRandomDataBlob_16MB_lzfse_delzfse()
    {
        XCTAssertEqual(CompressionTest.blob16mb, CompressionTest.blob16mb.lzfse_delzfse())
    }

    func testGzipCrcFail()
    {
        let b = 1024 * 16
        let ints = [UInt32](repeating: 0xcafeabee, count: b / 4)
        var zipped_blob = Data(bytes: ints, count: b).gzip()!

        let wrong_crc = Data(bytes: [0xcafeabee], count: 1)
        let range = (zipped_blob.count - 8)..<(zipped_blob.count - 4)
        zipped_blob.replaceSubrange(range, with: wrong_crc)

        XCTAssertNil(zipped_blob.gunzip())
    }

    func testGzipISizeFail()
    {
        let b = 1024 * 16
        let ints = [UInt32](repeating: 0xcafeabee, count: b / 4)
        var zipped_blob = Data(bytes: ints, count: b).gzip()!

        let wrong_isize = Data(bytes: [0xcafeabee], count: 1)
        let range = (zipped_blob.count - 4)..<(zipped_blob.count)
        zipped_blob.replaceSubrange(range, with: wrong_isize)

        XCTAssertNil(zipped_blob.gunzip())
    }
}

