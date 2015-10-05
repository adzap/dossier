class Dossier::MultiReport
  include Dossier::Model

  attr_accessor :options

  class << self
    attr_accessor :reports
  end

  def self.combine(*reports)
    self.reports = reports
  end
  
  def self.filename
    "#{report_name.parameterize}-report_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S-%Z')}"
  end

  def initialize(options = {})
    self.options = options.dup.with_indifferent_access
  end

  def reports
    @reports ||= self.class.reports.map { |report| 
      report.new(options).tap { |r|
        r.parent = self
      }
    }
  end

  def parent
    nil
  end

  def formatter
    Module.new
  end
  
  def dom_id
    nil
  end

  def template
    'multi'
  end

  def renderer
    @renderer ||= Dossier::Renderer.new(self)
  end

  def initialize_reports
    @reports ||= self.class.reports.map { |report| 
      report.new(options).tap { |r|
        r.parent = self
      }
    }
  end

  delegate :render, to: :renderer

  class UnsupportedFormatError < StandardError
    def initialize(format)
      super "Dossier::MultiReport only supports rendering in #{Dossier.configuration.multi_report_formats.joins(', ')} formats (you tried #{format})"
    end
  end
end
