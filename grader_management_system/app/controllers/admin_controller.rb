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
      
      data = response.parsed_response["data"] # get data from response
      classes_data = data["courses"] if data # get array of course objects from data

      if classes_data
        num = 1
        puts "Classes Data:"
        classes_data.each do |class_data|
          
          course = class_data["course"]
          puts "#{num})"
          puts "#{course["subject"]} #{course["catalogNumber"]} #{course["title"]}"
          puts "#{course["term"]}) Credits: #{course["maxUnits"]} (id: #{course["courseId"]})" 

          puts
          puts "Sections:"
          sections = class_data["sections"]
          sections.each do |indexedSection|
            puts "#{indexedSection["section"]} #{indexedSection["instructionMode"]} (fk: #{indexedSection["courseId"]})"
            meeting = indexedSection["meetings"].first
            instructor = meeting["instructors"].first
            puts "#{meeting["buildingDescription"]}, #{instructor["displayName"]}"
            puts "#{meeting["startDate"]}-#{meeting["endDate"]}"
            puts "#{meeting["startTime"]}-#{meeting["endTime"]}"
            days = ""
            if meeting["monday"] == true
              days += "Monday "
            end
            
            if meeting["tuesday"] == true
              days += "Tuesday "
            end

            if meeting["wednesday"] == true
              days += "Wednesday "
            end

            if meeting["thursday"] == true
              days += "Thursday "
            end

            if meeting["friday"] == true
              days += "Friday "
            end

            puts "#{days}"
            puts
          end
          puts
          num = num + 1
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
