class PhonesController < ApplicationController
	def create
    @person = Person.find(params[:person_id])
    @phone	= @person.phones.create(phone_params)

    redirect_to person_path(@person)
  end

  def destroy
    @phone = Phone.find(params[:id])
  end
 
  private
    def phone_params
      params.require(:phone).permit(:number)
    end
end
