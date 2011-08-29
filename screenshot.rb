require 'RMagick'

class Screenshot
  attr_reader :build_name, :feature, :browser, :scenario, :step

  def initialize image_path
    #acceptance/reports/screenshots/1095/User_doesn_t_submit_all_required_fields-__email_firstName_lastName___password___@ps-95_@ps-64_@ps-69_@ps-243/firefox/User_doesn_t_submit_all_required_fields-__email_firstName_lastName___password__/step-01.png
    if image_path =~ %r{acceptance/reports/screenshots/(\d+|local)/([^/]+)/([^/]+)/([^/]+)/step-(\d+).png$}
      @build_name = $1
      @feature = $2
      @browser = $3
      @scenario = $4
      @step = $5.to_i
    else
      raise "invalid image path #{image}"
    end
  end

  def id
    "#{browser}::#{feature}::#{scenario}::step-#{"%02d" % step}"
  end

  def image
    Magick::Image.read(file).first
  end

  def compare that
    puts "Comparing #{self}"

    that_image = that.image
    this_image = image

    rows = [this_image.rows, that_image.rows].min
    columns = [this_image.columns, that_image.columns].min

    this_image.crop(0, 0, columns, rows).compare_channel(that_image.crop(0, 0, columns, rows), ::Magick::MeanAbsoluteErrorMetric)
  end

  def to_s
    id
  end
end

class RemoteScreenshot < Screenshot
  attr_reader :artifacts_dir, :jenkins_build, :artifact_path

  def initialize artifacts_dir, jenkins_build, artifact_path
    super artifact_path

    @artifacts_dir = artifacts_dir
    @jenkins_build = jenkins_build
    @artifact_path = artifact_path
  end

  def file
    file = "#{@artifacts_dir}/#{@artifact_path}"
    if !File.exists?(file)
      @jenkins_build.fetch_artifact(@artifact_path, file)
    end
    file
  end
end

class LocalScreenshot < Screenshot
  attr_reader :file

  def initialize file
    super file

    @file = file
  end
end