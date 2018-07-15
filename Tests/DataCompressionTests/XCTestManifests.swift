
extension CompressionTest
{
    static var allTests = [
        ("testEmptyString", testEmptyString),
        ("testMiscSmall", testMiscSmall),
        ("testAsciiNumbers", testAsciiNumbers),
        ("testRandomDataChunks", testRandomDataChunks),
        ("testRandomDataBlob", testRandomDataBlob),
        ("testAdler32", testAdler32),
        ("testCrc32", testCrc32),
    ]
}
