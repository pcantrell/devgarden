$ ->
  $(document).on 'turbolinks:load', ->
    for elem in $('[data-collapse-children]')
      $elem = $(elem)
      $children = $elem.children()
      maxChildren = $elem.data('collapse-children')
      if $children.length > maxChildren
        $elem.removeAttr('data-collapse-children')
        $elem.attr('data-children-collapsed', 1)
        $children.slice(maxChildren).attr('data-collapsed-child', 1).hide()

        $reveal = $("
          <div class='more more-down'>
            <a href='#' data-show-collapsed-children>Show All</a>
          </div>")
        $elem.append($reveal)

  $(document).on 'click', '[data-show-collapsed-children]', (e) ->
    $(e.target).closest('[data-children-collapsed]').find('[data-collapsed-child]').slideDown()
    $(e.target).slideUp()
    e.preventDefault()
