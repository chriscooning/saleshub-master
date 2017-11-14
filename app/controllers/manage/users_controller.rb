class Manage::UsersController < Admin::BaseController
  def index
    authorize!(:access, service.build)
    users = User.without(current_user).paginate(pagination_scope)
    @users = UserDecorator.decorate_collection(users)
  end

  def new
    @user = service.build
    authorize!(:access, @user)
  end

  def show
    user = find_user(params[:id])
    @user = UserDecorator.decorate(user)
    authorize!(:access, @user)
  end

  def edit
    @user = find_user(params[:id])
    authorize!(:access, @user)
  end

  def create
    params[:password_confirmation] = params[:password] # this is not for user
    @user = service.create(user_params, User::Permissions::DEFAULT)
    authorize!(:access, @user)

    if @user.valid?
      flash[:notice] = "User was successfully created"
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    user = find_user(params[:id])
    authorize!(:access, user)

    unless params[:user][:password].present?
      params[:user].delete(:password)
    end

    @user = service.update(user, user_params)
    if @user.valid?
      flash[:notice] = "User was successfully updated"
      redirect_to action: :show
    else
      flash[:error] = "User was not updated due to errors"
      render :edit
    end
  end

  def destroy
    @user = find_user(params[:id])
    authorize!(:access, @user)
    if @user.destroy
      flash[:notice] = "User was destroyed"
    else
      flash[:error] = "User couldn't be destroyed"
    end
    redirect_to manage_users_path
  end

  def activate
    user = find_user(params[:id])
    authorize!(:activate, user)
    if user.activate
      flash[:notice] = "#{user.email} account has been activated"
    else
      flash[:error] = "There was an issue activating the account"
    end
    redirect_to manage_users_path
  end

  def deactivate
    user = find_user(params[:id])
    authorize!(:deactivate, user)
    if user.deactivate
      flash[:notice] = "#{user.email} account has been deactivated"
    else
      flash[:error] = "There was an issue disactivating the account"
    end
    redirect_to manage_users_path
  end

  private

  def service
    ::Services::Users.new(as: current_user)
  end

  def find_user(id)
    User.find(id)
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :password, :password_confirmation, :email, :role
    )
  end

  def current_user_id
    current_user && current_user.id
  end
end
