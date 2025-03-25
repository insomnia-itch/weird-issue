require "rails_helper"
require "color_namer"

describe "/photos/[ID]" do
  it "the comment textarea height automatically resizes itself", js: true do
    user = User.create(username: "cameron", email: "cameron@example.com", password: "password", avatar_image: "https://robohash.org/cameron")
    photo = Photo.create(image: "https://robohash.org/test", caption: "caption", owner_id: user.id)

    sign_in(user)

    visit "/photos/#{photo.id}"

    comment_textarea = find("textarea")
    old_height = comment_textarea.rect.height

    fill_in "comment[body]", with: "\n\n\n"
    new_height = comment_textarea.rect.height
    expect(old_height).to be < new_height
  end

  it "the count of characters in the comment textarea is automatically updated", js: true do
    user = User.create(username: "cameron", email: "cameron@example.com", password: "password", avatar_image: "https://robohash.org/cameron")
    photo = Photo.create(image: "https://robohash.org/test", caption: "caption", owner_id: user.id)

    sign_in(user)

    visit "/photos/#{photo.id}"

    expect(page).to have_content("There are 0 characters in this comment.")

    fill_in "comment[body]", with: "hi"

    expect(page).to have_content("There are 2 characters in this comment.")
  end

  it "the color of the character count changes from black/grey to red when the count exceeds 200", js: true do
    user = User.create(username: "cameron", email: "cameron@example.com", password: "password", avatar_image: "https://robohash.org/cameron")
    photo = Photo.create(image: "https://robohash.org/test", caption: "caption", owner_id: user.id)

    sign_in(user)

    visit "/photos/#{photo.id}"

    character_count_element = find(:element, exact_text: "0", visible: true)
    computed_color = character_count_element.style("color")["color"]
    actual_color = get_color_name(computed_color)

    expect(actual_color).to eq("black").or eq("grey")

    long_201_character_comment = <<~STRING
    Ruby is a dynamic, open-source programming language with that focuses on simplicity & productivity. It has an elegant syntax that is easy to read and  to write. Ruby was created by Yukihiro Matsumoto.
    STRING

    fill_in "comment[body]", with: long_201_character_comment

    expect(page).to have_content("There are 201 characters in this comment.")

    computed_color = character_count_element.style("color")["color"]
    red, green, blue = parse_rgba_value(computed_color).map(&:to_i)
    expect(red).to be > 200 
  end
end


def sign_in(user)
  visit "/users/sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password

  click_button "Sign in"
  expect(page).to have_current_path "/"
end

def parse_rgba_value(rgba)
  rgba.match(/rgba\((\d+), (\d+), (\d+), (\d+)\)/).captures
end

def get_color_name(color)
  red, green, blue = parse_rgba_value(color)
  color_array = ColorNamer.name_from_rgb(red, green, blue)

  color_array.last.downcase
end
