class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin

  def index
    # Load users that need approval (Instructors and Admins only)
    @users = User.where(approved: false, role: ["Instructor", "Admin"])
    # @users = User.all
  end

  def approve
    user = User.find(params[:id])
    user.approve
    redirect_to admin_path, notice: "User approved successfully."
  end

  def reload
    # This renders the form for reloading the database
  end

  def reload_database
    campus = params[:campus]
    semester = params[:semester]
  
    puts "DEBUG: reload_database action triggered"
    puts "Campus: #{campus}, Semester: #{semester}"

  
    response = HTTParty.get("https://contenttest.osu.edu/v2/classes/search",
        query: {
          q: 'cse',
          client: 'class-search-ui',
          campus: campus,
          term: semester,
          subject: 'cse'#,
        })

    if response.success?
      puts "API Request Success"

      # Clear course and section tables for repopulating
      Course.delete_all
      Section.delete_all


      data = response.parsed_response["data"] # get data from response
      classes_data = data["courses"] if data # get array of course objects from data

      if classes_data
        classes_data.each do |class_data|
          
          course = class_data["course"]

          # Create a new Course record
          new_course = Course.create!(
            subject: course["subject"],
            catalogNumber: course["catalogNumber"],
            title: course["title"],
            term: course["term"],
            campus: course["campus"],
            description: course["description"],
            credits: course["maxUnits"]
          )

          # Store the generated Rails course_id for linking sections to course
          course_id = new_course.id

          # Process sections for the current course
          sections = class_data["sections"]
          sections.each do |indexedSection|
            meeting = indexedSection["meetings"].first
            instructor = meeting["instructors"].first

            # Build the meetingDays string
            days = ""
            days += "Monday " if meeting["monday"]
            days += "Tuesday " if meeting["tuesday"]
            days += "Wednesday " if meeting["wednesday"]
            days += "Thursday " if meeting["thursday"]
            days += "Friday " if meeting["friday"]

            # Create a new Section record associated with the course
            Section.create!(
              courseId: course_id,
              sectionNumber: indexedSection["section"],
              instructionMode: indexedSection["instructionMode"],
              location: meeting["buildingDescription"],
              startTime: meeting["startTime"],
              endTime: meeting["endTime"],
              startDate: meeting["startDate"],
              endDate: meeting["endDate"],
              meetingDays: days.strip, # Removes trailing spaces
              instructorName: instructor["displayName"]
            )
          end
        end
      else
        puts "No courses found in the API response."
      end
  
      # Redirect to home after successful request
      redirect_to root_path, notice: "Database reloaded successfully."
    else
      puts "API Request Failed: #{response.code}"
      redirect_to reload_path, alert: "Failed to reload the database."
    end
  end

  private

  def check_if_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
