Location.find_or_create_by!(name: 'Innovation Space').update!(detail: 'Lower level of Markim Hall (IGC)')

def category(name)
  @category = RoleCategory.find_or_create_by!(name: name)
  yield
  @category = nil
end

def role(skill_name, person_name, desc = '')
  Role.create_with(category: @category).find_or_create_by!(skill_name: skill_name, person_name: person_name).
    update!(responsibilities: desc, category: @category)
end

category 'Technical' do
  role 'programming', 'programmer'
  role 'testing / QA', 'tester / QA'
  role 'ops', 'sysadmin'
end

category 'Design' do
  role 'graphic design', 'graphic designer'
  role 'UX design', 'UX designer'
  role 'art / illustration', 'artist / illustrator'
end

category 'Management' do
  role 'project management', 'project manager'
  role 'product management', 'product manager'
end

category 'Writing' do
  role 'copy editing', 'copy editor'
  role 'tech writing', 'tech writer'
  role 'copywriting', 'copywriter'
end

# category 'Business' do
#   role 'business analysis', 'business analyst'
#   role 'market research', 'market researcher'
# end
