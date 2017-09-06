class PhonesController < ApplicationController
	def create
    @person = Person.find(params[:person_id])
    @phone	= @person.phones.create(phone_params)

    redirect_to person_path(@person)
  end

  def destroy
    @person = Person.find(params[:person_id])
    @phone  = @person.phones.find(params[:id])
    @phone.destroy

    redirect_to person_path(@person)
  end
 
  private
    def phone_params
      params.require(:phone).permit(:number)
    end
end
