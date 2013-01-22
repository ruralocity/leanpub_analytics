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

    @incremented_royalties = @royalties.incremented_sums
    @incremented_sales = @sales.incremented_sums

    @incremented_royalties_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'line'
      f.legend(enabled: false)
      f.series(name: 'Total royalties', data: @incremented_royalties)
      f.title(text: 'Royalties over time')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Total royalties"} )
      f.options[:plotOptions][:line] = {
        cursor: 'pointer',
        point: { events: { click: %|function() { location.href = '/purchases/' + this.category }|.js_code } }
      }
    end

    @incremented_sales_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'line'
      f.legend(enabled: false)
      f.series(name: 'Total sales', data: @incremented_sales)
      f.title(text: 'Sales over time')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Total sales"} )
      f.options[:plotOptions][:line] = {
        cursor: 'pointer',
        point: { events: { click: %|function() { location.href = '/purchases/' + this.category }|.js_code } }
      }
    end

    @royalties_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Royalties', data: @royalties)
      f.title(text: 'Royalties by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Royalties"} )
      f.options[:plotOptions][:column] = {
        cursor: 'pointer',
        point: { events: { click: %|function() { location.href = '/purchases/' + this.category }|.js_code } }
      }
    end

    @sales_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Sales', data: @sales)
      f.title(text: 'Sales by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Sales"} )
      f.options[:plotOptions][:column] = {
        cursor: 'pointer',
        point: { events: { click: %|function() { location.href = '/purchases/' + this.category }|.js_code } }
      }
    end

    @average_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'line'
      f.legend(enabled: false)
      f.series(name: 'Royalty', data: @averages)
      f.title(text: 'Average royalty by month')
      f.xAxis(type: :datetime, categories: @dates)
      f.yAxis(min: 0, title: { text: "Royalty per book"} )
      f.options[:plotOptions][:line] = {
        cursor: 'pointer',
        point: { events: { click: %|function() { location.href = '/purchases/' + this.category }|.js_code } }
      }
    end
  end

  def show
    @purchases = Purchase.
      select("purchased_on, COUNT(id) AS total_sales, SUM(royalty) AS royalty, created_at").
      where("STRFTIME('%Y-%m', purchased_on) = ?", params[:id]).
      order("purchased_on ASC").
      group("purchased_on")

    @dates = @purchases.map(&:purchased_on)
    @royalties = @purchases.map(&:royalty)
    @sales = @purchases.map(&:total_sales)
    @averages = @purchases.map {|p| p.royalty/p.total_sales }

    @royalties_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Royalties', data: @royalties)
      f.title(text: 'Royalties by date')
      f.xAxis(type: :datetime, categories: @dates, labels: { rotation: 90, align: 'left' })
      f.yAxis(min: 0, title: { text: "Royalties"} )
    end

    @sales_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'column'
      f.legend(enabled: false)
      f.series(name: 'Sales', data: @sales)
      f.title(text: 'Sales by date')
      f.xAxis(type: :datetime, categories: @dates, labels: { rotation: 90, align: 'left' })
      f.yAxis(min: 0, title: { text: "Sales"} )
    end

    @average_chart = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = 'line'
      f.legend(enabled: false)
      f.series(name: 'Royalty', data: @averages)
      f.title(text: 'Average royalty by date')
      f.xAxis(type: :datetime, categories: @dates, labels: { rotation: 90, align: 'left' })
      f.yAxis(min: 0, title: { text: "Royalty per book"} )
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
