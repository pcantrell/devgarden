window.DevGarden ||= {}

# Adapted from https://github.com/mjackson/mjijackson.github.com/blob/master/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript.txt
rgbToHsl = (r, g, b) ->
  r /= 255
  g /= 255
  b /= 255
  max = Math.max(r, g, b)
  min = Math.min(r, g, b)
  h = 0
  s = 0
  l = (max + min) / 2
  d = max - min

  if max != min  # achromatic if equal
    s = d / if l > 0.5
      (2 - max - min)
    else
      (max + min)
    
    h = 60 * switch max
      when r then (g - b) / d + (if g < b then 6 else 0)
      when g then (b - r) / d + 2
      when b then (r - g) / d + 4

  [h, s, l]

DevGarden.huestogram = (sourceImage) ->
  hues = new Array(360).fill(0)

  image   = new CanvasImage(sourceImage)
  pixels  = image.getImageData().data
  for i in [0...pixels.length] by 4
      r = pixels[i    ]
      g = pixels[i + 1]
      b = pixels[i + 2]
      a = pixels[i + 3]
      [h,s,l] = rgbToHsl(r,g,b)
      hues[Math.round(h) % 360] += Math.pow(s,2) * (1 - Math.pow(2 * (l - 0.5), 4)) * a

  image.removeCanvas()
  max = Math.max.apply(Math, hues)
  return (Math.sqrt(hue / max) for hue in hues)

DevGarden.extractSignificantHues = ->
  1

DevGarden.rgbToHsl = rgbToHsl