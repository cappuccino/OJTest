require 'autotest'

Autotest.add_hook :initialize do |at|
  at.clear_mappings
  # watch out: Ruby bug (1.8.6):
  # %r(/) != /\//
  at.add_mapping(%r%^spec/.*Spec.j%) { |filename, _| 
    filename 
  }
  at.add_mapping(%r%^lib/(.*)\.j$%) { |_, m| 
    ["spec/#{m[1]}Spec.j"]
  }
  at.add_mapping(%r%^spec/(SpecHelper|shared/.*)\.j$%) { 
    at.files_matching %r%^spec/.*Spec\.j$%
  }
end

class Autotest::Ojspec < Autotest

  def initialize
    super
    self.failed_results_re = /^(?:\e\[\d*m)? - .*(?: FAILURE)?(?:\e\[\d*m)$/
    self.completed_re = /(?:\e\[\d*m)?\d+ specs/
  end

  def ojspec
    "ojspec"
  end
  
  def consolidate_failures(failed)
    filters = new_hash_of_arrays
    failed.each do |spec, trace|
      if trace =~ /\n(\.\/)?(.*Spec\.j):[\d]+:/
        filters[$2] << spec
      end
    end
    return filters
  end

  def make_test_cmd(files_to_test)
    return '' if files_to_test.empty?
    return "#{ojspec} #{files_to_test.keys.flatten.join(' ')} #{add_options_if_present}"
  end
  
  def add_options_if_present # :nodoc:
    File.exist?("spec/spec.opts") ? "-O spec/spec.opts " : ""
  end
end
