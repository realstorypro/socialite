# frozen_string_literal: true

module Airtable
  # Posts inside the "Feed" airtable
  class Post < Airrecord::Table
    self.base_key = 'appJpijjyEPNh87Vt'
    self.table_name = 'Feed'

    def self.unprocessed
      all(filter: '{Processed} = FALSE()')
    end

    def self.unpublished
      all(filter: 'AND( {Ready} = TRUE(), {Published} = FALSE() )')
    end

  end
end
