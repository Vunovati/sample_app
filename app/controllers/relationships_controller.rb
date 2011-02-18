class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format| # napravi primjerenu akciju s obzrom na vrstu zahtjeva. Samo jedna se izvrsava
      format.html { redirect_to @user } # odgovor HTML-om
      format.js  # odgovor javascriptom. Rails automatically calls a JavaScript Embedded Ruby 
      #(.js.erb) file with the same name as the action, i.e., create.js.erb or destroy.js.erb.
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user } # odgovor HTML-om
      format.js  # odgovor javascriptom
    end
  end
end

