struct UrlToDiscover: Hashable {
    public static let createCardSessions = UrlToDiscover([
        sessionsServiceKey, createCardSessionEndpointKey,
    ])
    public static let createCvcSessions = UrlToDiscover([
        sessionsServiceKey, createCvcSessionEndpointKey,
    ])
    public static let cardBinDetails = UrlToDiscover([cardBinDetailsKey])

    internal let keys: [KeyToDiscover]

    init(_ keys: [KeyToDiscover]) {
        self.keys = keys
    }

    private static let headersToTalkToSessionsService = [
        "content-type": ApiHeaders.sessionsHeaderValue,
        "accept": ApiHeaders.sessionsHeaderValue,
    ]

    private static let sessionsServiceKey = KeyToDiscover(
        "service:sessions"
    )
    private static let createCardSessionEndpointKey = KeyToDiscover(
        "sessions:card", headers: headersToTalkToSessionsService
    )
    private static let createCvcSessionEndpointKey = KeyToDiscover(
        "sessions:paymentsCvc", headers: headersToTalkToSessionsService
    )
    private static let cardBinDetailsKey = KeyToDiscover(
        "cardBinPublic:binDetails"
    )
}

struct KeyToDiscover: Hashable {
    let key: String
    var headers: [String: String]

    init(_ key: String, headers: [String: String]) {
        self.key = key
        self.headers = headers
    }

    init(_ key: String) {
        self.key = key
        self.headers = [:]
    }
}
