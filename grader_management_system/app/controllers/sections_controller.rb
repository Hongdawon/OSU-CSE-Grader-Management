class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  before_action :require_admin, :only => [:edit, :update, :destroy, :create, :new]

  # Rescue from ActiveRecord::RecordNotFound when a section is not found
  rescue_from ActiveRecord::RecordNotFound, with: :section_not_found

  # GET /sections or /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1 or /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
    session[:courseId] = params[:courseId]  # Storing courseId in session
    @section.courseId = params[:courseId]
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections or /sections.json
  def create
    @section = Section.new(section_params)
    @section.courseId = session[:courseId]  # Retrieving courseId from session
    
    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: "Section was successfully created." }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to @section, notice: "Section was successfully updated." }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section.destroy!

    respond_to do |format|
      format.html { redirect_to sections_path, status: :see_other, notice: "Section was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end
    # Handle cases where the section is not found
    def section_not_found
      redirect_to sections_path, alert: "Section not found."
    end


    # Only allow a list of trusted parameters through.
    def section_params
      params.require(:section).permit(:courseId, :sectionNumber, :instructionMode, :location, :startTime, :endTime, :startDate, :endDate, :meetingDays, :instructorName)
    end

    def require_admin
      unless current_user.admin?
        flash[:notice] = "You don't have access to this action"
        redirect_to courses_path
        return false
      end
    end
end
