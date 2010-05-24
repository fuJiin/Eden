class CustomLogger < Logger

  def format_message(severity, timestamp, progname, msg)
    "#{msg}"
  end

  def self.line
    CUSTOM_LOGGER.info("\n--------------------------------------------------\n")
  end

  def self.puts(description)
    CUSTOM_LOGGER.info("\n#{description}\n")
  end

  def self.debug(description, value)
    CUSTOM_LOGGER.info("\n#{description} = #{value.inspect}\n")
  end

  def self.var(&block)
     variable_name = block.call.to_s
     variable_value = eval(variable_name, block)
     CustomLogger.debug(variable_name, variable_value)
  end

  def self.exception(e)
    CustomLogger.debug("  exception", "#{e.message} | #{e.inspect} | #{e.backtrace.inspect}")
  end
end

file_full_path = File.expand_path('log/custom.log')
logfile = File.open(file_full_path, 'a')  #create log file
logfile.sync = true  #automatically flushes data to file
CUSTOM_LOGGER = CustomLogger.new(logfile)  #constant accessible anywhere