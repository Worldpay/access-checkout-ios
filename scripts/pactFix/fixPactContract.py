def has_colon(value):
    return value.find(":") > -1


def fix_json_path(value):

    result = ""

    for section in value.split("."):
        if result:  # This is not the first loop
            if has_colon(section):
                result += "['%s']" % section
            else:
                result += ".%s" % section
        else:  # First loop - don't change anything
            result += section

    return result


def fix_json_subdocument(jsondoc):
    updated_pact = {}

    for key, value in jsondoc.items():
        if has_colon(key):
            updated_pact[fix_json_path(key)] = value
        else:
            updated_pact[key] = value

    return updated_pact


def get_response_subdocuments(jsondoc):
    # interactions.[list].response.matchingRules.{dict}

    response_list = []
    interactions = jsondoc.get('interactions', [])

    for interaction in interactions:
        response = interaction.get('response')
        if response:
            response_list.append(response)

    return response_list


def fix_pact_contract(jsondoc):

    responses = get_response_subdocuments(jsondoc)

    for response in responses:
        matching_rules = response.get('matchingRules')
        if matching_rules:
            response['matchingRules'] = fix_json_subdocument(matching_rules)

    return jsondoc
