sizeCanvasToParent = ($canvas, $parent) ->
  devicePixelRatio = window.devicePixelRatio || 1
  width  = $parent.width()  * devicePixelRatio
  height = $parent.height() * devicePixelRatio
  $canvas.attr 'width',  width
  $canvas.attr 'height', height
  $canvas.css 'width',  "#{width  / devicePixelRatio}px"
  $canvas.css 'height', "#{height / devicePixelRatio}px"

drawingSetup = ($canvas) ->
  [$canvas[0].getContext('2d'),
   $canvas.attr('width'),
   $canvas.attr('height')]

renderDivider = ($canvas) ->
  [g, w, h] = drawingSetup($canvas)

  thickness = Math.max(2, h / 32)
  npts = 2
  phase = Math.floor(Math.random() * 2)
  pts = for n in [0...npts]
    x: (n + Math.random() * 0.8 - 0.4) / (npts-1) * w
    y: ((n + phase) % 2 * 2 - 1) * (h/2 - thickness)
  pts[0].x = 0
  pts[npts-1].x = w

  g.beginPath()

  p0 = pts[0]
  g.moveTo(p0.x, p0.y)

  curveTo = (p1, yoffset) =>
    taper = (x, y) => [x, (y + yoffset) * (Math.sin(x / w * Math.PI) + 0.2) + h / 2]

    [x0, y0] = taper(p0.x * 0.6 + p1.x * 0.4, p0.y)
    [x1, y1] = taper(p0.x * 0.4 + p1.x * 0.6, p1.y)
    [x2, y2] = taper(p1.x, p1.y)
    g.bezierCurveTo(x0, y0, x1, y1, x2, y2)

    p0 = p1

  for p1 in pts
    curveTo(p1, -thickness)
  for p1 in pts by -1
    curveTo(p1, thickness)

  g.closePath()
  g.fillStyle = '#888'
  g.fill()

$(document).on 'page:update', ->
  $('.divider').hide()
  # for divider in $('.divider')
  #   $canvas = $(divider).find('canvas')
  #   if $canvas.length == 0
  #     $canvas = $('<canvas/>').appendTo($(divider))
  #   sizeCanvasToParent $canvas, $(divider)
  #   renderDivider $canvas
