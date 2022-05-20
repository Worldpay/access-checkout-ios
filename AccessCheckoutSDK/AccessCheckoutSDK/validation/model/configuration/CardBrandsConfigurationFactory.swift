import Foundation

class CardBrandsConfigurationFactory {
    private let configurationFileRelativePath = "access-checkout/cardTypes.json"
    
    private let restClient: RestClient
    private let transformer: CardBrandDtoTransformer
    
    init(_ restClient: RestClient, _ transformer: CardBrandDtoTransformer) {
        self.restClient = restClient
        self.transformer = transformer
    }
    
    func create(baseUrl: String, acceptedCardBrands: [String], completionHandler: @escaping (CardBrandsConfiguration) -> Void) {
        guard let url = configurationFileUrl(from: baseUrl) else {
            completionHandler(CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: acceptedCardBrands))
            return
        }
        
        restClient.send(urlSession: URLSession.shared, request: URLRequest(url: url), responseType: [CardBrandDto].self) { result in
            let brands: [CardBrandModel]
            
            switch result {
            case .success(let dtos):
                brands = dtos.map { self.transformer.transform($0) }
            case .failure:
                brands = []
            }
            
            completionHandler(CardBrandsConfiguration(allCardBrands: brands, acceptedCardBrands: acceptedCardBrands))
        }
    }
    
    func emptyConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
    }
    
    private func configurationFileUrl(from baseUrl: String) -> URL? {
        let baseUrlWithTrailingSlash = baseUrl.last == "/" ? baseUrl : baseUrl + "/"
        
        return URL(string: "\(baseUrlWithTrailingSlash)\(configurationFileRelativePath)")
    }
}
