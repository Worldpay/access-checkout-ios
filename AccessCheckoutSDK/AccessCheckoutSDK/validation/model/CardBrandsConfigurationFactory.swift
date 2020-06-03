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
        let request = URLRequest(url: URL(string: "\(baseUrlWithTrailingSlash)\(configurationFileRelativePath)")!)
        
        restClient.send(urlSession: URLSession.shared, request: request, responseType: [CardBrandDto].self) { result in
            let brands: [CardBrand2]
            
            switch result {
            case .success(let dtos):
                brands = dtos.map { self.transformer.transform($0) }
            case .failure:
                brands = []
            }
            
            let configuration = CardBrandsConfiguration(brands, ValidationRulesDefaults.instance())
            completionHandler(configuration)
        }
    }
}
