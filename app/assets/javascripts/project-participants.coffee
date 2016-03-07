$(document).on 'turbolinks:load', ->
  noImage = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='

  personSearch = new Bloodhound(
    datumTokenizer: (x) -> x,  # unused
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote:
      url: '/people.json?q=%QUERY',
      wildcard: '%QUERY')

  $('#project-participants-form .participant').typeahead(
    null,
    name: 'people',
    display: 'full_name',
    source: personSearch,
    limit: 8,
    templates:
      empty: "None"
      suggestion: (person) ->
        $("
          <div class='search-result'>
            <img src='#{person.avatar_url || noImage}' class='icon'>
            <span class='text'>#{person.full_name}</span>
          </div>"))
