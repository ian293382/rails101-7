class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :quit]


  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    @group = Group.find(params[:id])
  end



    def update
      @group = Group.find(params[:id])
        if @group.update(group_params)
          redirect_to groups_path, notice: [ "update success"]
        else
          render :edit
        end
      end

    def destroy
      @group = Group.find(params[:id])
      @group.destroy
      redirect_to groups_path
    end

    def join
      @group = Group.find(params[:id])

      if !current_user.is_member_of?(@group)
        current_user.join!(@group)
        flash[:notice] = "加入本討論版成功"
      else
        flash[:warning] = "你已經是本討論版成員"
      end

      redirect_to group_path(@group)
    end


    def quit
      @group = Group.find(params[:id])

      if current_user.is_member_of?(@group)
        current_user.quit!(@group)
        flash[:alert] = "已經退出本討論版"
      else
        flash[:warning] = "你不是是本討論版成員,無法退出"
      end

      redirect_to group_path(@group)
    end


    private

    def group_params
      params.require(:group).permit(:title, :description)
    end


end
