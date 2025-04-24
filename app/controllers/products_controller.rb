class ProductsController < ApplicationController
  def search
    query = params[:query]
    if query.present?
      @products = fetch_products(query)
      render json: @products
    else
      render json: { error: 'Query parameter is missing' }, status: :bad_request
    end
  end

  private

  def fetch_products(query)
    url = URI.parse("https://us.openfoodfacts.org/api/v2/search?")
    params = {
      categories_tags_en: query,
      fields: 'code,product_name,brands,brand_owner,image_url',
      sort_by: 'last_modified_t',
      page_size: 50,
      json: true
      
    }
    url.query = URI.encode_www_form(params)
    response = Net::HTTP.get(url)
    JSON.parse(response)['products']
    #http://localhost:3000/products/search?query=
  end
end