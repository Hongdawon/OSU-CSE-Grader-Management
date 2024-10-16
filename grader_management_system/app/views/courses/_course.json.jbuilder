json.extract! course, :id, :subject, :catalogNumber, :title, :term, :campus, :description, :credits, :created_at, :updated_at
json.url course_url(course, format: :json)
