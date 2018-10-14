require "spec_helper"

class ServiceNotReady < StandardError
end

context "after provisioning finished" do
  describe server(:server1) do
    describe capybara("http://#{server(:server1).server.address}:8280") do
      it "shows Welcome to Jenkins!" do
        visit "/jenkins/"
        expect(page).to have_content "Welcome to Jenkins!"
      end

      it "allows to login" do
        visit "/jenkins/login"
        fill_in("j_username", with: "admin")
        fill_in("j_password", with: "password")
        click_on("Sign in")
        find_button("Sign in").trigger("click")
        visit "/jenkins/"
        expect(page).to have_content "Please create new jobs to get started."
        expect(page).to have_content "log out"
      end

      it "shows users" do
        visit "/jenkins/"
        find_link("People").trigger("click")
        expect(page).to have_content "admin"
      end
    end
  end
end
