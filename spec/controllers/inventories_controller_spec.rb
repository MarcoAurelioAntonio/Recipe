require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  let(:user) { User.create(name: 'Shahadat Hossain', email: 'test@example.com', password: '12345678') }
  let(:inventory) { Inventory.create(name: 'Inventory 1', user:) }
  describe 'GET #index' do
    context 'when user is logged in' do
      before do
        user.confirm
        sign_in user
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns the current user to @user' do
        get :index
        expect(assigns(:user)).to eq user
      end

      it "assigns the user's inventories to @inventories" do
        get :index
        expect(assigns(:inventories)).to eq [inventory]
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end

      it 'returns http redirect' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in and is the owner of the inventory' do
      before do
        user.confirm
        sign_in user
        get :show, params: { id: inventory.id }
      end

      it 'assigns the current user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'assigns the inventory to @inventory' do
        expect(assigns(:inventory)).to eq inventory
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end

      it 'returns a success status code' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not logged in' do
      before do
        get :show, params: { id: inventory.id }
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'displays a flash message asking to log in' do
        expect(flash[:alert]).to match(/need to sign in/)
      end
    end

    context 'when user is logged in but is not the owner of the inventory' do
      let(:other_user) { User.create(name: 'Sohidul Islam', email: 'sohidul@example.com', password: '12345678') }
      let(:other_inventory) { Inventory.create(name: 'Inventory 2', user: other_user) }

      before do
        user.confirm
        sign_in user
        get :show, params: { id: other_inventory.id }
      end

      it 'redirects to the inventory index page' do
        expect(response).to redirect_to(inventories_path)
      end

      it 'displays a flash unauthorized message' do
        expect(flash[:notice]).to eq 'You are not authorized to view this inventory.'
      end
    end
  end
end
