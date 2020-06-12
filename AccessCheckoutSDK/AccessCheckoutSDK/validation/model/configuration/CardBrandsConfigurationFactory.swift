class CardBrandsConfigurationFactory {
    private let configurationFileRelativePath = "access-checkout/cardTypes.json"
    
    private let restClient: RestClient
    private let transformer: CardBrandDtoTransformer
    
    init(_ restClient: RestClient, _ transformer: CardBrandDtoTransformer) {
        self.restClient = restClient
        self.transformer = transformer
    }
    
    func create(baseUrl: String, completionHandler: @escaping (CardBrandsConfiguration) -> Void) {
        let baseUrlWithTrailingSlash = baseUrl.last == "/" ? baseUrl : baseUrl + "/"
        guard let url = URL(string: "\(baseUrlWithTrailingSlash)\(configurationFileRelativePath)") else {
            completionHandler(CardBrandsConfiguration([]))
            return
        }
        
        restClient.send(urlSession: URLSession.shared, request: URLRequest(url: url), responseType: [CardBrandDto].self) { result in
            let brands: [CardBrandModel]
            
            switch result {
            case .success(let dtos):
                brands = dtos.map { self.transformer.transform($0) }
            case .failure(_):
                brands = []
            }
            
            completionHandler(CardBrandsConfiguration(brands))
        }
    }
    
    func emptyConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration([])
    }
    
    private func configurationFileUrl(baseUrl:String) -> URL? {
        let baseUrlWithTrailingSlash = baseUrl.last == "/" ? baseUrl : baseUrl + "/"
        
        return URL(string: "\(baseUrlWithTrailingSlash)\(configurationFileRelativePath)")
    }
}
