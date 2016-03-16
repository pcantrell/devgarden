puts "Populating seed data"

Project.transaction do

  # ──────┨  Location  ┠──────

  Location.find_or_create_by!(name: 'Innovator Space').update!(detail: 'Lower level of Markim Hall (IGC)')

  # ──────┨  Role  ┠──────

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
    role 'translation', 'translator'
  end

  # category 'Business' do
  #   role 'business analysis', 'business analyst'
  #   role 'market research', 'market researcher'
  # end

  # ──────┨  Tag  ┠──────

  def tags(key, category_name)
    @tag_order = (@tag_order || 0) + 1
    @tag_category = TagCategory.create_with(name: category_name).find_or_create_by!(key: key)
    @tag_category.update!(name: category_name, order: @tag_order)
    yield
    @tag_category = nil
  end

  def tag(name, **opts)
    if long_name = opts.delete(:long_name)
      opts[:short_name] = name
      name = long_name
    end

    opts.reverse_merge!(
      name: name,
      category: @tag_category)

    if tag = Tag.where("lower(name) IN (?)", [name, opts[:short_name]].compact.map(&:downcase)).first
      tag.update!(**opts)
    else
      Tag.create!(**opts)
    end
  end

  tags :family, "Project Type" do
    tag "Mobile", long_name: "Mobile App", url: "https://en.wikipedia.org/wiki/Mobile_app"
    tag "Web", long_name: "Web App", url: "https://en.wikipedia.org/wiki/Web_application"
    tag "Desktop", long_name: "Desktop App", url: "https://en.wikipedia.org/wiki/Application_software"
    tag "Language", long_name: "Programming Langauge", url: "https://en.wikipedia.org/wiki/Programming_language"
    tag "Library", url: "https://en.wikipedia.org/wiki/Library_(computing)"
  end

  tags :platform, "Platform / Framework" do
    tag "Android", long_name: "Android SDK", url: "https://developer.android.com"
    tag "Angular", url: "https://angularjs.org"
    tag "App Engine", long_name: "Google App Engine", url: "https://cloud.google.com/appengine/"
    tag "iOS", long_name: "iOS SDK", url: "https://developer.apple.com/ios"
    tag "PhoneGap", long_name: "PhoneGap / Cordova", url: "https://cordova.apache.org"
    tag "libGDX", url: "https://libgdx.badlogicgames.com"
    tag "Pixi", long_name: "Pixi.js", url: "http://www.pixijs.com"
    tag "Node", long_name: "Node.js", url: "https://nodejs.org"
    tag "Ionic", url: "http://ionicframework.com"
    tag "Rails", long_name: "Ruby on Rails", url: "http://rubyonrails.org"
  end

  tags :tool, "Tool" do
    tag "Spark", long_name: "Spark Java", url: "http://sparkjava.com"
    tag "jQuery", url: "https://jquery.com"
    tag "Hibernate", url: "http://hibernate.org"
    tag "Postgres", long_name: "PostgreSQL", url: "https://www.postgresql.org"
    tag "Firebase", url: "https://www.firebase.com"
    tag "Heroku", url: "https://www.heroku.com"
  end

  tags :language, "Language" do
    tag "HTML", url: "https://en.wikipedia.org/wiki/HTML"
    tag "CSS", url: "https://en.wikipedia.org/wiki/Cascading_Style_Sheets"
    tag "JS", long_name: "Javascript", url: "https://en.wikipedia.org/wiki/JavaScript"
    tag "CoffeeScript", url: "http://coffeescript.org"
    tag "Java", url: "https://www.java.com"
    tag "Obj-C", long_name: "Objective-C"
    tag "Ruby", url: "https://www.ruby-lang.org"
    tag "Python", url: "https://www.python.org"
    tag "Swift", url: "https://swift.org/about/"
  end

end
