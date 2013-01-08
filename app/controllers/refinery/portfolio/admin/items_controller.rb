module Refinery
  module Portfolio
    module Admin
      class ItemsController < ::Refinery::AdminController
        include Refinery::Portfolio

        crudify :'refinery/portfolio/item',
                :order => 'position ASC',
                :xhr_paging => true

        before_filter :find_gallery, :only => [:index]

        def index
          if params[:orphaned]
            @items = Item.orphaned.order('position ASC')
          elsif params[:gallery_id]
            @items = @gallery.items.order('position ASC')
          else
            redirect_to refinery.portfolio_admin_galleries_path and return
          end

          @items = @items.page(params[:page])
        end

        def new
          if params[:gallery_id].present?
            @item = Item.new(:gallery_id => find_gallery.id )
          else
            @item = Item.new
          end
        end

        private
        def find_gallery
          @gallery = Gallery.find(params[:gallery_id])
        end

      end
    end
  end
end
