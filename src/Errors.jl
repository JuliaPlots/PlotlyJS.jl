#
# Error Functions
#

function throw_enumerate_error(validvalues)
  if length(validvalues) <= 10
    #Simple Value List#
    values = join(validvalues, "\n\t-")
    msg = "This object must take one of the values from \n\t-$(values)"
    error(msg)
  else
    #Large Number of valid Values#
    first = validvalues[1:5]
    last = validvalues[end-5:end]
    msg = "This object must take one of the values from \n\t-$(first)...\n\t-$(last)"
    #NOTE: Should we add a docstring link here
  end
end
