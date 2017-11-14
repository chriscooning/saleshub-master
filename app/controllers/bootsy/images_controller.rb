module Bootsy
  class ImagesController < ApplicationController
    # GET /images
    # GET /images.json
    def index
      authorize!(:access, Action.new(:messages, :create))

      @gallery = find_gallery
      @images = @gallery.images

      respond_to do |format|
        format.html # index.html.erb
        format.json do
          rendered_images = []

          @images.each do |image|
            rendered_images << render_to_string(file: 'bootsy/images/_image',
                                                layout: false,
                                                formats: [:html],
                                                locals: { image: image })
          end

          new_image = render_to_string(file: 'bootsy/images/_new',
                                       layout: false,
                                       formats: [:html],
                                       locals: { gallery: @gallery, image: @gallery.images.new })

          render json: { images: rendered_images, form: new_image }
        end
      end
    end

    # POST /images
    # POST /images.json
    def create
      authorize!(:access, Action.new(:messages, :create))

      @gallery = find_gallery
      @gallery.save! unless @gallery.persisted?
      @image = Image.new image_params
      @image.image_gallery_id = @gallery.id

      respond_to do |format|
        if @image.save
          image_view = render_to_string(file: 'bootsy/images/_image',
                                        layout: false,
                                        formats: [:html],
                                        locals: { image: @image })

          new_image = render_to_string(file: 'bootsy/images/_new',
                                       layout: false,
                                       formats: [:html],
                                       locals: { gallery: @gallery, image: @gallery.images.new })

          format.json { render json: { image: image_view, form: new_image, gallery_id: @gallery.id } }
        else
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /images/1
    # DELETE /images/1.json
    def destroy
      authorize!(:access, Action.new(:messages, :create))

      @image = Image.find(params[:id])
      @image.destroy

      respond_to do |format|
        format.json { render json: { id: params[:id] } }
        format.html { redirect_to images_url }
      end
    end

    private

    def find_gallery
      ImageGallery.find(params[:image_gallery_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:image_file)
    end
  end
end