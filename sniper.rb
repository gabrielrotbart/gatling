include Magick

class Comparison

  def initialize expected, actual
    @expected = expected
    @actual = actual
  end
  
  def capture
    page.driver.browser.save_screenshot('temp.png')
    temp_screenshot = Image.read('temp.png').first
  end
  
  def crop_element
    element = @actual.native
    location = element.location
    size = element.size
    capture.crop(location.x, location.y, size.width, size.height)
  end
  
    def save_crop_as_reference(cropped_element)   
       actual_filename = "#{@expected}".sub(/\.[a-z]*/,'')
       puts actual_filename
        cropped_element.write('#{actual_filename}_candidate.png')
     end   

    
  def matches?
     cropped_element = crop_element
     if File.exists? (@expected)
       expected_img = Image.read(@expected).first
       diff_metric = cropped_element.compare_channel(expected_img, MeanAbsoluteErrorMetric)
       matches = diff_metric[1] == 0.0
       diff_metric.first.write('diff.png') unless matches
       matches
     else
       save_crop_as_reference(cropped_element)
       raise "The design reference #{@expected} does not exist, #{@expected}_candidate.png is now available to be used as a reference"     
      end    
    end  
  end