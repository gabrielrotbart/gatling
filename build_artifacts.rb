require 'rubygems'
require 'net/http'
require 'fileutils'
require 'find'

class BuildArtifacts
end

class RemoteBuildArtifacts < BuildArtifacts
  attr_reader :jenkins_build

  def initialize jenkins_build
    @jenkins_build = jenkins_build
    @build_dir = CamelliaTool.path("tmp", "jenkins", jenkins_build.jenkins_job.job_name, jenkins_build.build_number.to_s)
    @artifacts_zip_file = File.join(@build_dir, "artifacts.zip")
    @artifacts_dir = File.join(@build_dir, "artifacts")
  end

  def screenshots
    if !@screenshots
      if ENV['GATLING_PREFETCH_ARTIFACTS'] == 'true'
        fetch_artifacts
      end

      artifacts = @jenkins_build.json[:artifacts]
      @screenshots = Hash[artifacts.select { |artifact| artifact[:relativePath] =~ /\.png$/ }.collect { |artifact|
        screenshot = RemoteScreenshot.new(@artifacts_dir, @jenkins_build, artifact[:relativePath])
        [screenshot.id, screenshot]
      }]
    end
    @screenshots
  end

  private
  def fetch_artifacts
    if !File.exists?(@artifacts_zip_file)
      @jenkins_build.fetch_artifact("*zip*/archive.zip", @artifacts_zip_file)
      FileUtils.rm_rf @artifacts_dir
    end

    if !File.exists?(@artifacts_dir)
      `unzip -d #{@build_dir} #{@artifacts_zip_file}`
      `mv #{@build_dir}/archive #{@artifacts_dir}`
    end
  end
end

class LocalBuildArtifacts < BuildArtifacts
  def screenshots
    if !@screenshots
      dir = CamelliaTool.path("acceptance", "reports", "screenshots", "local")
      @screenshots = Hash[Dir["#{dir}/**/*.png"].collect { |file|
        screenshot = LocalScreenshot.new(file)
        [screenshot.id, screenshot]
      }]
    end
    @screenshots
  end
end
