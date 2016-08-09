# Ruby doesn't include "." in $LOAD_PATH. Here, I add it for `pry`.
current_directory = File.dirname(__FILE__)
$LOAD_PATH.unshift(current_directory)
require 'lib/pipeable'
include Pipeable
