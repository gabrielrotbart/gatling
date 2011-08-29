require 'rubygems'
require 'RMagick'
require 'build_artifacts'
require 'screenshot'

class VisualBuild
  def differences that, diff_dir, feature=nil, scenario=nil, step=nil
    puts "Comparing #{self} with #{that}"

    screenshots = screenshots(feature, scenario, step)

    (screenshots.keys & that.artifacts.screenshots.keys).sort.each do |id|
      screenshot = screenshots[id]
      that_screenshot = that.artifacts.screenshots[id]
      diff_img, val = screenshot.compare(that_screenshot)

      if (val > 0) then
        dest_dir = File.join(diff_dir, screenshot.feature, screenshot.browser, screenshot.scenario)
        dest_img = File.join(dest_dir, "#{screenshot.build_name}-#{that_screenshot.build_name}-step-#{"%02d" % screenshot.step}.png")
        FileUtils.mkdir_p dest_dir
        diff_img.write(dest_img)
      end

      # force garbage collection to avoid ImageMagick/RMagick memory leak
      # See http://rubyforge.org/forum/forum.php?thread_id=1374&forum_id=1618
      GC.start
    end
  end

  private
  def screenshots feature, scenario, step
    Hash[artifacts.screenshots.select { |id, screenshot|
      ((feature.nil? || screenshot.feature == feature) &&
          (scenario.nil? || screenshot.scenario == scenario) &&
          (step.nil? || screenshot.step == step.to_i))
    }]
  end
end

class RemoteVisualBuild < VisualBuild
  attr_reader :jenkins_build, :artifacts

  def initialize jenkins_build
    @jenkins_build = jenkins_build
    @artifacts = RemoteBuildArtifacts.new(jenkins_build)
  end

  def build_name
    jenkins_build.build_number.to_s
  end

  def to_s
    "#{jenkins_build}"
  end
end

class LocalVisualBuild < VisualBuild
  attr_reader :artifacts

  def initialize
    @artifacts = LocalBuildArtifacts.new
  end

  def build_name
    "local"
  end

  def to_s
    build_name
  end
end