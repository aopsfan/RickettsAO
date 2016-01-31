# wavefunction_graph.rb

class WavefunctionGraph
  attr_reader :datasets
  
  def initialize
    @datasets = []
    @positions = []
  end
  
  def configure(x0, xn, dx, options)
    steps = 0.step(3, 0.01)
    @positions = steps.map{|s| Position.new(s)}
  end
  
  def dump(options)
    @datasets = []
    @positions = []
  end
  
  def plot(wavefunction, title)
    x = @positions.map{|pos| pos.r}
    y = @positions.map{|pos| wavefunction.call(pos)}
    
    dataset = Gnuplot::DataSet.new([x,y]) do |ds|
      ds.with = "lines"
      ds.title = title
    end
    
    @datasets << dataset
    dataset
  end
  
  def add(other_datasets)
    @datasets += other_datasets # currently boycotting every language except ruby !!
  end
  
  def write_plots(filename, options)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.terminal "png"
        plot.output File.expand_path(filename + ".png", __FILE__)
        
        plot.title options[:title]
        plot.xlabel "r"
        plot.ylabel "wf"
        
        plot.data = @datasets
      end
    end
  end
  
  def to_s
    "#{@datasets.length} plots"
  end
end