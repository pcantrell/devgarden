$ ->
  h = (s) -> $("<div/>").text(s).html()

  noImage = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='

  bounce = ($elem) ->
    $elem
      .css(transformOrigin: '0 50%')
      .transition { scale: 1.1 },  80, 'easeOutSine'
      .transition { scale: 1   }, 320, 'easeInOutSine'

  rebuildParticipantsDOM = ->
    $participants = $('#participants')
    $participants.children().remove()
    for person in $participants.data('participants')
      $newParticipant = $("
        <li class='participant'>
          <div class='name'>#{h person.full_name}</div>
          <div class='admin'>
            <input type='checkbox' id='admin#{person.id}' #{if person.admin then 'checked' else ''}>
            <label for='admin#{person.id}'>Admin</label>
            <button class='remove'>Remove</button>
          </div>
        </li>")
      $newParticipant.data('person', person)
      $participants.append($newParticipant)
    return

  getParticipants = -> $('#participants').data('participants')

  window.DevGarden.setParticipants =
  setParticipants = (participants) ->
    $('#participants').data('participants', participants)
    rebuildParticipantsDOM()

  addParticipant = (newPerson) ->
    return unless newPerson && newPerson.id

    $('#new-participant input[type=text]').val("")
    showErrorMessage("")

    participants = getParticipants()
    existingIndex = (i for person, i in participants when person.id == newPerson.id)[0]
    if existingIndex
      bounce $($('#participants li')[existingIndex])
    else
      participants.push(newPerson)
      rebuildParticipantsDOM()

  removeParticipant = (toRemove) ->
    participants = getParticipants()
    setParticipants(
      person for person in participants when person.id != toRemove.id)

  reorderParticipantsFromDOM = ->
    setParticipants(
      $(elem).data('person') for elem in $('#participants li'))

  showErrorMessage = (message) ->
    $('#new-participant .inline-error').text(message)


  # Typeahead / person selection

  $(document).on 'turbolinks:load', ->
    personSearch = new Bloodhound(
      datumTokenizer: (x) -> x,  # unused
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote:
        url: '/people.json?q=%QUERY',
        wildcard: '%QUERY')

    $('#new-participant-name').typeahead(
      null,
      name: 'people',
      display: 'full_name',
      source: personSearch,
      limit: 8,
      templates:
        suggestion: (person) -> $("
          <div class='search-result'>
            <img src='#{person.avatar_url || noImage}' class='icon'>
            <span class='text'>#{h person.full_name}</span>
          </div>"))
  
  $(document).on 'typeahead:select', (e, person) ->
    setTimeout (-> addParticipant(person)), 1

  $(document).on 'keydown', '#new-participant', (e) ->
    errorMessage = ""

    if e.which == 13 && $('#new-participant-name').val()
      e.preventDefault()

      typeahead = $('#new-participant-name').data('ttTypeahead')
      results = typeahead.menu._getSelectables()
      if results.length == 1
        typeahead.select(results)
      else if results.length > 1
        errorMessage = "Please select a name from the list"
      else
        errorMessage = "Nobody with that name"

    showErrorMessage(errorMessage)

  # Changing admin status

  $(document).on 'change', '#participants .admin input', (e) ->
    person = $(e.target).closest('li').data('person')
    person.admin = !person.admin

  # Reordering participants

  $(document).on 'turbolinks:load', ->
    if list = $('#participants')[0]
      Sortable.create(
        list,
        animation: 150,
        #handle: ".tile__title",
        draggable: "li",
        onUpdate: -> reorderParticipantsFromDOM())


  # Removing participants

  $(document).on 'click', '#participants .remove', (e) ->
    person = $(e.target).closest('.participant').data('person')
    if confirm "Remove #{person.full_name} from the project?"
      removeParticipant(person)
