scrollAhead = 100


$infiniteScroll = []
dirty = false

updateInfiniteScroll = ->
  unless dirty
    dirty = true
    setTimeout updateInfiniteScrollNow, 50

updateInfiniteScrollNow = ->
  dirty = false

  scrollBottom = $(window).scrollTop() + $(window).height() + scrollAhead

  for container in $infiniteScroll
    $container = $(container)
    $more = $container.find('.more')
    if $more.length > 0 && scrollBottom > $more.offset().top
      href = $more.find('a').attr('href')
      $more.remove()
      $container.append($('<div class="loading">Loading…</div>'))
      loadMore($container, href)

loadMore = ($container, href) ->
  $.ajax
    url: href
    success: (data) ->
      $container.find('.loading').remove()
      $container.append(data)
    error: ->
      setTimeout (-> loadMore($container, href)), 5000

$(document).on 'page:update', ->
  $infiniteScroll = $('.infinite-scroll')
  updateInfiniteScroll()

$(document).on 'scroll', updateInfiniteScroll
