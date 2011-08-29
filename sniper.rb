

class Sniper

  def initialize(selenium)
     @selenium = selenium
  end

  def assert_element_matches_design element_path, design_reference
    pid = $$

    $driver.save_screenshot("/home/wpol/projects/camellia/acceptance/reports/screenshot-#{pid}.png")

    element = @selenium.find_element(:xpath => element_path)
    location = element.location
    size = element.size

    screenshot_dir = '/home/wpol/projects/camellia/acceptance/reports'
    screenshot_file = "#{screenshot_dir}/#{design_reference}"
    FileUtils::mkdir_p(File::dirname screenshot_file)

    reference_dir = File::expand_path 'design-reference'
    reference_file = "#{reference_dir}/#{design_reference}"
    FileUtils::mkdir_p(File::dirname reference_file)

    `convert /home/wpol/projects/camellia/acceptance/reports/screenshot-#{pid}.png -crop #{size.width}x#{size.height}+#{location.x}+#{location.y} #{screenshot_file}`

    raise "A design reference for #{design_reference} does not exist.\nTo use the current screenshot as the design reference, run:\n cp #{screenshot_file} #{reference_file}" unless File.exists? "#{reference_file}"

    FileUtils::rm_rf '/home/wpol/projects/camellia/acceptance/reports/screenshot-differences'
    FileUtils::mkdir_p "/home/wpol/projects/camellia/acceptance/reports/wpm-screenshot-differences/#{pid}"

    difference = `compare -metric ae #{screenshot_file} #{reference_file} /home/wpol/projects/camellia/acceptance/reports/wpm-screenshot-differences/#{pid}/difference.png 2>&1`
    difference = difference.chomp

    raise "Design reference doesn't match - Check /home/wpol/projects/camellia/acceptance/reports/screenshot-differences/#{pid} to see the differences.\nTo update the reference using the current screenshot, run:\n cp #{screenshot_file} #{reference_file}" unless $?.success? and difference == "0"
  end

end