require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase" do
    assert_difference('Purchase.count') do
      post :create, purchase: { bundle_slug: @purchase.bundle_slug, coupon_code: @purchase.coupon_code, coupon_note: @purchase.coupon_note, email: @purchase.email, leanpub_id: @purchase.leanpub_id, paid_on: @purchase.paid_on, purchased_on: @purchase.purchased_on, royalty: @purchase.royalty, total_paid: @purchase.total_paid }
    end

    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should show purchase" do
    get :show, id: @purchase
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase
    assert_response :success
  end

  test "should update purchase" do
    put :update, id: @purchase, purchase: { bundle_slug: @purchase.bundle_slug, coupon_code: @purchase.coupon_code, coupon_note: @purchase.coupon_note, email: @purchase.email, leanpub_id: @purchase.leanpub_id, paid_on: @purchase.paid_on, purchased_on: @purchase.purchased_on, royalty: @purchase.royalty, total_paid: @purchase.total_paid }
    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should destroy purchase" do
    assert_difference('Purchase.count', -1) do
      delete :destroy, id: @purchase
    end

    assert_redirected_to purchases_path
  end
end
