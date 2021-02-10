require "colorize"

class String
  def colorize_table
    gsub!(/\d/, &:yellow)
    gsub!(/[-+&%|]/, &:cyan)
    # gsub!(/of/, &:red)
    # gsub!(/for/, &:red)
    # gsub!(/with/, &:red)
    # gsub!(/BBQ/, &:yellow)
  end

  def colorize_text
    gsub!(/\d/, &:yellow)
    gsub!(/[-+&%|='>]/, &:cyan)
    # gsub!(/of/, &:red)
    # gsub!(/for/, &:red)
    # gsub!(/with/, &:red)
    # gsub!(/from/, &:red)
    # gsub!(/if/, &:red)
    # gsub!(/in/, &:red)
    # gsub!(/BBQ/, &:yellow)
  end
end
