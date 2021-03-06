require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do

  describe "Viewing the list of projects" do

    it "shows the projects" do
      visit 'http://example.com/projects'

      expect(page).to have_text("4 Projects")
    end

    it "shows the movie's details" do
  project = Project.create(project_attributes)

  visit project_url(project)

  expect(page).to have_text(project.name)
  expect(page).to have_text(project.looking_for)
  expect(page).to have_text("$700,000.00")
  expect(page).to have_text(project.description)
  expect(page).to have_text(project.teams)
end
 end


describe "Navigating projects" do
  it "allows navigation from the detail page to the listing page" do
    project = Project.create(project_attributes)


    visit project_url(project)

    click_link "All Projects"

    expect(current_path).to eq(projects_path)
  end

  it "allows navigation from the listing page to the detail page" do
    project = Project.create(project_attributes)


    visit project_url

    click_link project.name

    expect(current_path).to eq(projects_path(project))
  end
end

describe "Editing a project" do

  it "updates the project and shows the project's updated details" do
    project = Project.create(project_attributes)

    visit project_url(project)

    click_link 'Edit'

    expect(current_path).to eq(edit_project_path(project))

    expect(find_field('Name').value).to eq(project.name)

    fill_in 'Name', with: "Updated Project Name"

    click_button 'Update Project'

    expect(current_path).to eq(project_path(project))

  end
end

describe "Creating a new project" do
  it "saves the project and shows the new movie's details" do
    visit projects_url

    click_link 'Add New Project'

    expect(current_path).to eq(new_project_path)

    fill_in "Name", with: "New Project name"
    fill_in "Description", with: "A lot of the most popular sites on the web are for photo sharing. But the sites classified as social networks are also largely about photo sharing. As much as people like to share words (IM and email and blogging are "word sharing" apps), they probably like to share pictures more. It's less work and the results are usually more interesting. I think there is huge growth still to come. There may ultimately be 30 different subtypes of image/video sharing service, half of which remain to be discovered"
    fill_in "looking for", with: "Partnership"
    fill_in "Target Amount", with: "75000000"
    fill_in "Teams", with: "K Wellie"
    fill_in "Github Link", with: "http://github.com/sct"
    fill_in "Web Url", with: "http://masfr.com/sct"
    fill_in "Image File", with: "image.png"


    # If you're taking advantage of the HTML 5 date field in Chrome,
    # you'll need to use 'fill_in' rather than 'select'
    # fill_in "Released on", with: (Time.now.year - 1).to_s

    click_button 'Create Project'

    expect(current_path).to eq(project_path(Project.last))

    expect(page).to have_text('New Project Name')
  end
end

describe "Deleting a project" do
  it "destroys the project and shows the project listing without the deleted project" do
    project = Project.create(project_attributes)

    visit project_path(project)

    click_link 'Delete'

    expect(current_path).to eq(projects_path)
    expect(page).not_to have_text(project.name)
  end
end

describe 'validation' do
  it "requires a name" do
    project = Project.new(name: "")

    project.valid?  # populates errors

    expect(project.errors[:name].any?).to be_true
  end

  it "requires a description" do
    project = Project.new(description: "")

    project.valid?

    expect(project.errors[:description].any?).to be_true
  end

  it "requires a released on date" do
    project = Project.new(looking_for: "")

    project.valid?

    expect(project.errors[:looking_for].any?).to be_true
  end

  it "requires a duration" do
    project = Project.new(target_amount: "")

    project.valid?

    expect(project.errors[:target_amount].any?).to be_true
  end

  it "requires a description over 24 characters" do
    project = Project.new(description: "X" * 24)

    project.valid?

    expect(project.errors[:description].any?).to be_true
  end

  it "is valid with example attributes" do
    project = Project.new(project_attributes)

    expect(project.valid?).to be_true
  end
end

describe 'create project' do

  it "does not save the project if it's invalid" do
  visit new_project_url

  expect {
    click_button 'Create Project'
  }.not_to change(Project, :count)

  expect(current_path).to eq(projects_path)
  expect(page).to have_text('error')
end
end

describe 'edit project' do

  it "does not update the project if it's invalid" do
  project = Project.create(project_attributes)

  visit edit_project_url(project)

  fill_in 'Name', with: " "

  click_button 'Update Project'

  expect(page).to have_text('error')
end
end

describe 'project review' do
  it "has many reviews" do
  project = Project.new(project_attributes)

  review1 = project.reviews.new(review_attributes)
  review2 = project.reviews.new(review_attributes)

  expect(project.reviews).to include(review1)
  expect(project.reviews).to include(review2)
end

  it "deletes associated reviews" do
    project = Project.create(project_attributes)

    project.reviews.create(review_attributes)

    expect {
      project.destroy
    }.to change(Review, :count).by(-1)
  end
end



end

