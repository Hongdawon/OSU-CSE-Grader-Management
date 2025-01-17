class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :require_admin, :only => [:edit, :update, :destroy, :create, :new]

  # Rescue from ActiveRecord::RecordNotFound
  rescue_from  ActiveRecord::RecordNotFound, with: :course_not_found

  # GET /courses or /courses.json
  def index
    @pagy, @courses = pagy(Course.all)
  end

  # GET /courses/1 or /courses/1.json
  def show
    @sections = Section.where(courseId: @course.id) # Fetch all sections for the course
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Define what happens when a course is not foudn 
    def course_not_found
      # Redirect to courses index oage with an error message
      redirect_to courses_path, alert: "Course not found."
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:subject, :catalogNumber, :title, :term, :campus, :description, :credits)
    end
    
    def require_admin
      unless current_user.admin?
        flash[:notice] = "You don't have access to this action"
        redirect_to courses_path
        return false
      end
    end
end
