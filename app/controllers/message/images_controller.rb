class Message::ImagesController < Manage::BaseController
  respond_to :json, only: [:create, :destroy]

  def create
    if (message = find_message).present?
      authorize_by_type_and_action!(message.message_type, :update)
    elsif cannot?(:access, Action.new(:messages, :create)) &&
      cannot?(:access, Action.new(:briefings, :create)) &&
      cannot?(:access, Action.new(:whats_ups, :create))

      raise CanCan::AccessDenied
    end

    gallery = find_or_create_gallery

    if params[:files].present?
      results = []
      errors = []

      params[:files].each do |file|
        image = gallery.images.build(file: file)

        if image.save
          results << {
            image: {
              gallery_id: image.message_gallery_id,
              url: message_gallery_image_path(gallery, image),
              file: {
                url: image.file.url,
                thumbnail_url: image.file.thumbnail.url
              }
            }
          }
        else
          errors << {
            image: {
              original_file_name: file.original_filename,
              errors: image.errors.full_messages
            }
          }
        end
      end

      respond_to do |format|
        format.html {  
          render json: {
            results: results,
            errors: errors
          }, 
          content_type: 'text/html',
          layout: false
        }
        format.json {  
          render json: {
            results: results,
            errors: errors
          }
        }
      end
    else
      render json: {
        errors: ['Files was not present']
      }
    end
  end

  def destroy
    authorize!(:access, Action.or(:message, [:edit, :create]))
    image = find_image

    if image.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def find_or_create_gallery
    params[:gallery_id].eql?('new') ? create_gallery : find_gallery
  end

  def create_gallery
    message = find_message

    Message::Gallery.create do |object|
      object.created_by = current_user
      object.message = message
    end
  end

  def find_gallery
    Message::Gallery.
      where('created_by_id = ? OR message_id IS NOT NULL', current_user.id).
      find(params[:gallery_id])
  end

  def find_image
    find_gallery.images.find(params[:id])
  end

  def find_message
    params[:message_id] ? Message.find(params[:message_id]) : nil
  end
end
