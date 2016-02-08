class SVGPath
  def initialize
    @path = ""
  end

  def move_to(x, y)
    command "M", x, y
  end

  def line_to(x, y)
    command "L", x, y
  end

  def cubic_to(x0, y0, x1, y1, x, y)
    command "C", x0, y0, x1, y1, x, y
  end

  def close
    command "Z"
  end

  def to_s
    @path
  end

private

  def command(cmd, *coords)
    @path << "  " << cmd
    coords.each do |coord|
      @path << " %1.3g" % coord
    end
  end

end
