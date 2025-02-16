require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get comments_create_url
    assert_response :success
  end

  test "should get destroy" do
    get comments_destroy_url
    assert_response :success
  end

  test "should get like" do
    get comments_like_url
    assert_response :success
  end

  test "should get dislike" do
    get comments_dislike_url
    assert_response :success
  end
end
