module WavefunctionPlot
  def WavefunctionPlot.plot(title='Wavefunction')
    g = Gruff::Line.new
    g.title = title
    g.hide_dots = true
    # g.left_margin = -150
    g.show_vertical_markers = true
    g.theme = Gruff::Themes::PASTEL
    g.labels = {0 => "0", 10 => "1", 20 => "2", 30 => "3"}
    
    g
  end
end