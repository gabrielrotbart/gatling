require 'camellia/tool'
require 'camellia/jenkins/job'
require 'visual_build'
require 'optparse'

class Gatling < CamelliaTool
  def self.parse_args!(defaults={})
    opts = defaults.dup
    args = []
    OptionParser.new("Usage: gatling [OPTIONS] baseline_num:target_num [baseline_num:target_num]") do |parser|
      parser.on("--feature=FEATURE") { |feature| opts[:feature] = feature }
      parser.on("--scenario=SCENARIO") { |scenario| opts[:scenario] = scenario }
      parser.on("--step=STEP") { |step| opts[:step] = scenario }
      parser.on("--job=JOB") { |job| opts[:job] = job }
      parser.on("--baseline-job=JOB") { |job| opts[:baseline_job] = job }
      args =parser.parse!
    end
    raise "Please provide --job" unless opts[:job]
    opts[:baseline_job] ||= opts[:job]
    return [opts, args]
  end

  def self.exec
    opts, args = parse_args!
    raise "Please provide at least one build number pair" if args.empty?
    args.each do |pair|
      baseline_num, target_num = pair.split(":")
      target_num ||= "lastSuccessfulBuild"
      gatling = Gatling.new(opts[:baseline_job], opts[:job],
                  baseline_num, target_num,
                  opts[:feature], opts[:scenario], opts[:step])
      gatling.run
    end
  end

  def initialize baseline_job, target_job, baseline_build_name, target_build_name, feature, scenario, step
    baseline_job = JenkinsJob.new(baseline_job)
    target_job = JenkinsJob.new(target_job)
    @baseline_build = visual_build(baseline_job, baseline_build_name)
    @target_build = visual_build(target_job, target_build_name)
    @feature = feature
    @scenario = scenario
    @step = step
  end

  def run
    puts "Comparing build #{@baseline_build} to #{@target_build}"
    @diff_dir = CamelliaTool.path("acceptance", "reports", "screenshots", "#{@baseline_build.build_name}-#{@target_build.build_name}")
    FileUtils.rm_rf @diff_dir
    FileUtils.mkdir_p @diff_dir

    @baseline_build.differences(@target_build, @diff_dir, @feature, @scenario, @step)
  end

  private
  def visual_build job, build_name
    if build_name == "local"
      LocalVisualBuild.new
    else
      jenkins_build = job.build(build_name)
      RemoteVisualBuild.new(jenkins_build)
    end
  end
end

class LocalGatling < Gatling
  def self.exec
    opts, args = parse_args!()
    (args || [":"]).each do |pair|
      baseline_num, target_num = pair.split(":")
      baseline_num ||= "lastSuccessfulBuild"
      gatling = LocalGatling.new(opts[:baseline_job],
                  baseline_num,
                  opts[:feature], opts[:scenario], opts[:step])
      gatling.run
    end
  end

  def initialize job, baseline_build_name, feature, scenario, step
    super job, baseline_build_name, baseline_build_name, "local", feature, scenario, step
  end
end
