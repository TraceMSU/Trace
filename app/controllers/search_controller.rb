require 'roo'

class SearchController < ApplicationController
  def search
    query = params[:q].to_s.strip  # Ensure the query is stripped of leading/trailing spaces
    Rails.logger.info "Search query: '#{query}'"
    results = search_products_from_excel(query)
    render json: { query: query, results: results }
  end

  private

  def search_products_from_excel(query)
    excel_file_path = Rails.root.join('lib', 'data', 'testdata.xls').to_s
    Rails.logger.info "Excel file path: #{excel_file_path}"

    unless File.exist?(excel_file_path)
      Rails.logger.error "Error: Excel file not found at path #{excel_file_path}"
      return []
    end

    begin
      workbook = Roo::Excel.new(excel_file_path)
      sheet = workbook.sheet(0)

      if sheet.last_row < 2
        Rails.logger.error "Error: Not enough data in the Excel file."
        return []
      end

      header_row = sheet.row(1).map(&:to_s).map(&:downcase)
      data_rows = (2..sheet.last_row)

      results = []
      data_rows.each do |row_num|
        row = sheet.row(row_num)

        product_data = {}
        header_row.each_with_index do |header_cell, index|
          data_cell = row[index]
          product_data[header_cell] = data_cell.nil? ? '' : data_cell.to_s.strip
        end

        Rails.logger.info "Row #{row_num} data: #{product_data.inspect}"

        # Check for any nil or empty values
        empty_value_found = false
        product_data.each do |key, value|
          if value.nil? || value.to_s.strip.empty?
            Rails.logger.warn "Warning: Empty value found for key '#{key}' in row #{row_num}"
            empty_value_found = true
            break # Skip this row entirely if any value is empty
          end
        end

        # Skip processing this row if it has empty values
        next if empty_value_found

        # Proceed with matching the query (case-insensitive comparison without downcase)
        match_found = false
        product_data.each do |key, value|
          # Strip the value and query to remove any extra spaces and compare
          value = value.nil? ? '' : value.to_s.strip
          query = query.strip # Ensure query is always a string and stripped

          # Log the type and value before comparison
          Rails.logger.info "Checking value for key '#{key}' (value class: #{value.class}): #{value.inspect}"

          # Safeguard: Skip nil or empty values before comparison
          if value.empty?
            Rails.logger.warn "Skipping empty value for key '#{key}' in row #{row_num}"
            next
          end

          # Check if the query matches any part of the value (use include? for substring matching)
          if value.include?(query)
            Rails.logger.info "Match found for row #{row_num}: #{product_data}"
            match_found = true
            break
          end
        end

        if match_found
          results << product_data
        end
      end

      Rails.logger.info "Total results found: #{results.count}"
      results

    rescue => e
      Rails.logger.error "Error reading Excel file: #{e.message}"
      []
    end
  end
end