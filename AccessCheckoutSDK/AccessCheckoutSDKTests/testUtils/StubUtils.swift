import Mockingjay
import XCTest

class StubUtils {
    
    static func stubSuccessfulGetResponse(url: String, responseAsString: String){
        XCTestCase().stub(http(.get, uri: url), toResponse(responseAsString: responseAsString, responseCode: 200))
    }
    
    static func stubGetResponse(url: String, responseAsString: String, responseCode: Int){
        XCTestCase().stub(http(.get, uri: url), toResponse(responseAsString: responseAsString, responseCode: responseCode))
    }
    
    private static func toResponse(responseAsString: String, responseCode: Int) -> (URLRequest) -> Response {
        return jsonData(toData(responseAsString), status: responseCode)
    }
    
    private static func toData(_ stringData:String) -> Data {
           return stringData.data(using: .utf8)!
   }
}
