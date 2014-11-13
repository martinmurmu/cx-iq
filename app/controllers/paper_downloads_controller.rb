class PaperDownloadsController < ApplicationController
  
  def new
    @paper_download = PaperDownload.new
  end
  
  def create
    @paper_download = PaperDownload.new(paper_download_params)
    captcha_ok = verify_nice_captcha #to generate 'try again' on recaptcha
    @paper_download.errors.add :base, "Wrong captcha" if !captcha_ok
    @paper_download.paper_link = "http://www.amplifiedanalytics.com/pdfs/recipe_for_revenue_growth.pdf"
        
    if captcha_ok and @paper_download.save
      UserMailer.paper_download(@paper_download).deliver
      UserMailer.paper_download_info(@paper_download).deliver
      @email = params[:paper_download][:email]
    else
      render :action => :new
    end
  end


  def test
    @email = "test@test.com"
    render :create
  end
    
  def paper_download_params
    params.require(:paper_download).permit(:email, :first_name, :last_name, :company)
  end  
end
