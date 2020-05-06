class ApiResponseLinkLookup {
    func lookup(link: String, in apiResponse: ApiResponse) -> String?{
        return apiResponse.links.endpoints.mapValues({ $0.href })[link]
    }
}
