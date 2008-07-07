factories :articles

steps_for :comment do
  Given "the comment is approved" do
    @comment.update_attributes! :approved => true
  end
  
  Given "the comment is not approved" do
    @comment.update_attributes! :approved => false
  end
  
  When "the user has submitted a comment to the blog article" do
    When "the user goes to the url /2008/1/1/the-article-title"
    And "the user fills in the form with his name, email and comment"
    And "the user clicks the 'Submit comment' button"
    @comment = Comment.find(:first)
  end
  
  When "the user fills in the form with his name, email and comment" do
    fills_in 'name', :with => 'an anonymous name'
    fills_in 'e-mail', :with => 'anonymous@email.org'
    fills_in 'comment_body', :with => 'the comment body'
  end
  
  When "the user goes to the comment show page" do
    get comment_path(@comment)
  end
  
  Then "the page has a comment creation form" do
    response.should have_form_posting_to(comments_path)
    @form = css_select 'form[action=?]', '/comments'
  end

  Then "the page does not have a comment creation form" do
    response.should_not have_form_posting_to(comments_path)
  end
  
  Then "the page has a comment edit form" do
    response.should have_form_putting_to(comments_path)
    @form = css_select 'form[action=?]', '/comments'
  end
  
  Then "the user is redirected to the comment show page" do
    request.request_uri.should == comment_path(@comment)
    response.should render_template('comments/show')
  end
end