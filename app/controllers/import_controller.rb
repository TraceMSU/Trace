class ImportController < ApplicationController
    def import_products
      uploaded_file = params[:file]
  
      if uploaded_file.present?
        begin
          spreadsheet = Roo::Spreadsheet.open(uploaded_file.path) # Use uploaded file
  
          header = spreadsheet.row(1).map(&:downcase)
  
          products = []
          # Dynamic row range
          first_data_row = 2 # Assuming data starts on row 2
          last_data_row = spreadsheet.last_row
  
          (first_data_row..last_data_row).each do |i|
            row = spreadsheet.row(i)
            product_data = {}
  
            header.each_with_index do |col_name, index|
              product_data[col_name] = row[index].to_s if row[index].present? # Convert to string!
            end
  
            product = Product.new(
              brand: product_data['brand'],
              owner: product_data['owner'],
              ownershiptype: product_data['ownershiptype']
              # ... other attributes
            )
            products << product
          end
  
          if products.present?
            Product.import(products, validate: false) # Use activerecord-import. Remove validate: false if you need validations.
            render json: { message: "Products imported successfully!" }, status: :ok
          else
            render json: { error: "No products found in the file or all rows were empty." }, status: :unprocessable_entity
          end
  
        rescue => e
          Rails.logger.error "Import error: #{e.message}" # Log the error!
          render json: { error: "Error processing file: #{e.message}" }, status: :unprocessable_entity
        end
  
      else
        render json: { error: "No file uploaded." }, status: :bad_request
      end
    end
  end