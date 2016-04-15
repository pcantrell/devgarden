$ ->
  # ────── Helpers ──────

  h = (s) -> $("<div/>").text(s).html()

  noImage = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='

  bounce = ($elem) ->
    $elem
      .css(transformOrigin: '0 50%')
      .transition { scale: 1.1 },  80, 'easeOutSine'
      .transition { scale: 1   }, 320, 'easeInOutSine'

  showIf = (condition, str) ->
    if condition
      str
    else
      ''

  # ────── View ──────

  participantsChanged = ->
    $participantList = $('#project-participants ol')
    $participantList.children().remove()
    for person, index in getParticipants()
      $newParticipant = $("
        <li class='participant'>
          <div class='handle'></div>
          <input type='hidden'
                 name='project[participants][][kind]'
                 value='#{person.kind}'>
          <input type='hidden'
                 name='project[participants][][key]'
                 value='#{person.key}'>
          <div class='title #{person.kind}'>#{h person.name}</div>
          <button class='remove' #{showIf person.self, 'disabled'}>⊖</button>
          <div class='options'>
            #{
              showIf person.self,
                "<input type='hidden'
                        name='project[participants][][admin]'
                        value='on'>"
            }
            <input type='checkbox'
                   id='participant-admin-#{index}'
                   name='project[participants][][admin]'
                   #{showIf person.self, 'disabled'}
                   #{showIf person.admin, 'checked'}>
            <label for='participant-admin-#{index}'>Admin</label>
          </div>
        </li>")
      $newParticipant.data('person', person)
      $participantList.append($newParticipant)

    return

  # ────── State manipulation ──────

  getParticipants = ->
    $('#project-participants').data('participants')

  setParticipants = (participants, save = true) ->
    $('#project-participants').data('participants', participants)
    participantsChanged()
    if save
      $('#project-participants').trigger('devgarden:scheduleAutosave')
    participants

  addParticipant = (newPerson) ->
    return unless newPerson && newPerson.id

    $('#new-participant input[type=text]').val("")
    showErrorMessage("")

    participants = getParticipants()
    console.log participants
    existingIndex = (                     \
      i for person, i in participants     \
        when person.kind == 'participant' \
          && person.key == newPerson.id   \
      )[0]
    if existingIndex?
      bounce $($('#project-participants li')[existingIndex])
    else
      participants.push
        kind: 'participant',
        name: newPerson.name,
        key: newPerson.id
      setParticipants(participants)  # trigger update

  removeParticipant = (toRemove) ->
    participants = getParticipants()
    setParticipants(
      person                              \
        for person in participants        \
        when person.kind != toRemove.kind \
          || person.key  != toRemove.key)

  reorderParticipantsFromDOM = ->
    setParticipants(
      $(elem).data('person') for elem in $('#project-participants li'))

  showErrorMessage = (message) ->
    $('#new-participant .inline-error').text(message)

  # ────── Events & Interactions ──────

  # Initial population

  $(document).on 'turbolinks:load', ->
    if initialParticipants = $('#initialParticipants').attr('data-initial-participants')
      setParticipants(JSON.parse(initialParticipants), false)

  # Changing admin status

  $(document).on 'change', '#project-participants .admin input', (e) ->
    person = $(e.target).closest('li').data('person')
    person.admin = !person.admin

  # Reordering participants

  $(document).on 'turbolinks:load', ->
    if list = $('#project-participants ol')[0]
      Sortable.create(
        list,
        animation: 150,
        handle: ".handle",
        draggable: "li",
        onUpdate: -> reorderParticipantsFromDOM())

  # Removing participants

  $(document).on 'click', '#project-participants .remove', (e) ->
    person = $(e.target).closest('.participant').data('person')
    if confirm "Remove #{person.name} from the project?"
      removeParticipant(person)

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
      display: 'name',
      source: personSearch,
      limit: 8,
      templates:
        suggestion: (person) -> $("
          <div class='search-result'>
            <img src='#{person.avatar_url || noImage}' class='icon'>
            <span class='text'>#{h person.name}</span>
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
