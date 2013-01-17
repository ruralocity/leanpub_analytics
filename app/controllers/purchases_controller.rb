class PurchasesController < ApplicationController

  def index
    @purchases = Purchase.
      select("STRFTIME('%Y-%m', purchased_on) AS purchased_month, COUNT(id) AS total_sales, SUM(royalty) AS royalty, created_at").
      order("purchased_on ASC").
      group("STRFTIME('%Y-%m', purchased_on)")

    @dates = @purchases.map(&:purchased_month)
    @royalties = @purchases.map(&:royalty)
    @sales = @purchases.map(&:total_sales)
    @averages = @purchases.map {|p| p.royalty/p.total_sales }

    @royalties_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Royalties', data: @royalties)
      f.title(text: 'Royalties by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Royalties"} )
    end

    @sales_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Sales', data: @sales)
      f.title(text: 'Sales by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Sales"} )
    end

    @average_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'line'
      f.legend(enabled: false)
      f.series(name: 'Royalty', data: @averages)
      f.title(text: 'Average royalty by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Sales"} )
    end
  end

  def new
    @purchase = Purchase.new
  end

  def create
    Purchase.import(params[:file])
    redirect_to purchases_url, notice: "Imported purchases."
  end
end
