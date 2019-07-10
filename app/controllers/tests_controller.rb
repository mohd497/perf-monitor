class TestsController < ApplicationController
  before_action :get_test, only: [:show]

  
  def index
    @tests = Test.where(url: params[:url]).select("url, ttfb, ttfp, speed_index, is_passed, max_ttfb, max_tti, max_ttfp, max_speed_index, created_at").as_json(:except => :id)

    render json: @tests
  end

  
  def show
    if @test
      render json: @test
    else
      render json: {error: "Test can't be found"}, status: 404
    end  
  end

  # POST /tests
  def create
    @test = Test.new(test_params)
    if @test.save
      render json: {"ttfb": @test.ttfb,"ttfp": @test.ttfp,"tti": @test.tti,"speed_index": @test.speed_index,"passed": @test.is_passed}, 
        status: :created, location: @test
    else
      render json: @test.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_test
      @test = Test.where(url: params[:url]).select("url, ttfb, ttfp, speed_index, is_passed, max_ttfb, max_tti, max_ttfp, max_speed_index, created_at").last.as_json(:except => :id)
    end

    # Only allow a trusted parameter "white list" through.
    def test_params
      params.require(:test).permit(:url, :max_ttfb, :max_tti, :max_speed_index, :max_ttfp)
    end
end
