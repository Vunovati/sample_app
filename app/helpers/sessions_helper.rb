module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token  # or equals, zove funkciju samo prvi put (short circuit evaluation)
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) # koristimo array sa dva elementa kao argument metode
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil] # ako je vrijednost lijevog nil onda vrati dva nil-a
    end
end


