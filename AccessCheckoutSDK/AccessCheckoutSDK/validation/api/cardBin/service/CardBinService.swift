import Foundation

internal class CardBinService {
    private let checkoutId: String
    private let client: CardBinApiClient
    private let configurationProvider: CardBrandsConfigurationProvider

    /// Initialises a new CardBinService instance
    ///
    /// - Parameters:
    ///   - checkoutId: The checkout session identifier
    ///   - client: The API client for making requests
    ///   - configurationProvider: Provider for card brand configurations
    init(
        checkoutId: String,
        client: CardBinApiClient,
        configurationProvider: CardBrandsConfigurationProvider
    ) {
        self.checkoutId = checkoutId
        self.client = client
        self.configurationProvider = configurationProvider
    }

    /// Retrieves card brand information based on the provided card number and optional global brand.
    ///
    /// - Parameters:
    ///   - globalBrand: An optional global card brand model to use for validation rules
    ///   - cardNumber: The card number to perform BIN lookup on
    ///   - completion: Completion handler with the result containing an array of card brand models or an error
    func getCardBrands(
        globalBrand: CardBrandModel?,
        cardNumber: String,
        completion: @escaping (Result<[CardBrandModel], AccessCheckoutError>) -> Void
    ) {
        client.abort()

        client.retrieveBinInfo(cardNumber: cardNumber, checkoutId: checkoutId) { result in
            switch result {
            case .success(let response):
                let cardBrands = self.transform(
                    globalBrand: globalBrand,
                    response: response
                )
                completion(.success(cardBrands))
            case .failure(let error):
                NSLog("Failed to retrieve Card BIN info: \(error.localizedDescription)")
            }
        }
    }

    /// Converts the API response and optional global brand into a deduplicated array of card brand models.
    ///
    /// - Parameters:
    ///   - globalBrand: An optional global card brand model to use for validation rules
    ///   - response: The response from the card BIN API containing brand information
    /// - Returns: An array of deduplicated card brand models
    private func transform(
        globalBrand: CardBrandModel?,
        response: CardBinResponse
    ) -> [CardBrandModel] {
        if globalBrand == nil && response.brand.isEmpty {
            return []
        }

        let configuration = configurationProvider.get()
        let defaults = ValidationRulesDefaults.instance()

        var cvcValidationRule = defaults.cvc
        var panValidationRule = defaults.pan

        if let globalBrand = globalBrand {
            cvcValidationRule = globalBrand.cvcValidationRule
            panValidationRule = globalBrand.panValidationRule
        }

        let responseBrands = response.brand.map { brandName in
            findBrandByName(brandName, in: configuration, globalBrand: globalBrand)
                ?? CardBrandModel(
                    name: brandName,
                    images: [],
                    panValidationRule: panValidationRule,
                    cvcValidationRule: cvcValidationRule
                )
        }

        let allBrands = ([globalBrand].compactMap { $0 } + responseBrands)
            .reduce(into: [String: CardBrandModel]()) { result, brand in
                let key = brand.name.lowercased()
                if result[key] == nil {
                    result[key] = brand
                }
            }
            .map { $0.value }
            .sorted { $0.name < $1.name }

        return allBrands
    }

    /// Searches for a card brand by name within the provided configuration.
    ///
    /// - Parameters:
    ///   - brandName: The name of the card brand to search for
    ///   - configuration: The card brands configuration to search within
    ///   - defaultBrand: An optional default card brand model to match against
    /// - Returns: The matching card brand model if found, otherwise nil
    private func findBrandByName(
        _ brandName: String,
        in configuration: CardBrandsConfiguration,
        globalBrand: CardBrandModel?
    ) -> CardBrandModel? {
        if let globalBrand = globalBrand,
            brandName.caseInsensitiveCompare(globalBrand.name) == .orderedSame
        {
            return globalBrand
        }

        return configuration.allCardBrands.first { brand in
            brand.name.caseInsensitiveCompare(brandName) == .orderedSame
        }
    }
}
