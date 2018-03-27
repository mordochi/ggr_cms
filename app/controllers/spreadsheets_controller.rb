class SpreadsheetsController < ApplicationController
  before_action :set_api, only: [:show]
  before_action :set_spreadsheet, only: [:show]
  

  def new
    @spreadsheet = Spreadsheet.new
  end

  def create
    @spreadsheet = Spreadsheet.new(spreadsheet_params)
    @spreadsheet.spreadsheet_id =  @spreadsheet.spreadsheet_id.split('/')[5]
    if @spreadsheet.save
      redirect_to spreadsheet_path(@spreadsheet)
    else
      #add restriction for unvailid url 
      render :new
    end
  end

  def show
    @responses = @service.get_spreadsheet(@spreadsheet.spreadsheet_id)
    @tabs = @service.get_spreadsheet(@spreadsheet.spreadsheet_id, fields: "sheets.properties").sheets
    #讀tab名稱col名稱
  end

  private

  def set_api
    require 'google/apis/sheets_v4'
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.key = 'AIzaSyCw1eTY-S9Xuxqv4AZ_bfHDlxEJ3KsLuig'
    @service.authorization = nil
  end

  def set_spreadsheet
    @spreadsheet = Spreadsheet.find(params[:id])    
  end

  def spreadsheet_params
    params.require(:spreadsheet).permit(:spreadsheet_id)
  end
end
