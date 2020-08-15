# frozen_string_literal: true
class Admin::MembersController < ApplicationController
  before_action :set_admin_member, only: [:show, :edit, :update, :destroy]

  layout "admin"

  # GET /admin/members
  def index
    @admin_members = User.where(role: :member, subdomain: current_user.subdomain)
  end

  # GET /admin/members/1
  def show; end

  # GET /admin/members/new
  def new
    @admin_member = User.new(role: :member)
  end

  # GET /admin/members/1/edit
  def edit; end

  # POST /admin/members
  def create
    @admin_member = User.new(admin_member_params)
    @admin_member.password = SecureRandom.hex
    @admin_member.role = :member
    @admin_member.subdomain = current_user.subdomain
    @admin_member.skip_confirmation!
    # @admin_member.invitation_completed = true
    if @admin_member.save(validate: false)
      redirect_to admin_member_path(@admin_member), notice: 'Member was successfully created.'
    else
      flash.now[:notice] = @admin_member.errors.full_messages.first
      render :new
    end
  end

  # PATCH/PUT /admin/members/1
  def update
    if @admin_member.update(admin_member_params)
      redirect_to admin_member_path(@admin_member), notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/members/1
  def destroy
    @admin_member.destroy
    redirect_to admin_members_url, notice: 'Member was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_member
    @admin_member = User.find_by(id: params[:id], role: 'member', subdomain: current_user.subdomain)
  end

  # Only allow a list of trusted parameters through.
  def admin_member_params
    params.require(:admin_member).permit(:fname, :lname, :email, :profile_picture)
  end
end
