class UsersController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      render json: { result: true, user_id: user.id }
    else
      render json: { result: false, message: user.errors.full_messages.join(", ") }, status: 422
    end
  end

  def login
    user = User.find_by(document_type: params[:document_type], document_number: params[:document_number])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { result: true, token: token, user_id: user.id }
    else
      render json: { result: false, message: "Неверные учетные данные" }, status: 401
    end
  end

  def logout
    render json: { result: true }
  end

  def info
    user = User.find_by(id: params[:id])
    return render json: { result: false, message: "Пользователь не найден" }, status: :not_found unless user
    render json: {
      result: true,
      first_name: user.first_name,
      second_name: user.second_name,
      family_name: user.family_name,
      document_type: user.document_type,
      document_number: user.document_number,
      birth_date: user.birth_date,
    }
  end

  private

  def user_params
    params.permit(:first_name, :second_name, :family_name, :birth_date, :document_type, :document_number, :password)
  end

  def encode_token(payload)
    JWT.encode(payload, "secret")
  end
end
