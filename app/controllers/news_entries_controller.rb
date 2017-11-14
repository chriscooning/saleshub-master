class NewsEntriesController < ApplicationController
  def internal
    set_action(:news)

    authorize!(:access, Action.new(:news, :read))
    fetch_internal_news_entries

    if request.xhr?
      render '_items', layout: false, locals: { news_entries: @internal_news_entries, enable_actions: true }
    else
      @total_count = NewsEntry.internal.count
    end
  end

  def external
    set_action(:news)
    authorize!(:access, Action.new(:news, :read))
    fetch_external_news_entries

    if request.xhr?
      render '_items', layout: false, locals: { news_entries: @external_news_entries }
    else
      @total_count = NewsEntry.external.count
    end
  end

  def show
    authorize!(:access, Action.new(:news, :read))
    news_entry = NewsEntry.find(params[:id])
    @news_entry = NewsEntryDecorator.decorate(news_entry)
  end

  def new
    authorize!(:access, Action.new(:news, :create))
    @news_entry = NewsEntry.new
  end

  def create
    authorize!(:access, Action.new(:news, :create))
    @news_entry = service.create_internal(news_entry_params)

    if @news_entry.valid?
      flash[:notice] = "News entry was successfully created"

      redirect_to news_path(@news_entry)
    else
      flash[:error] = "Please check your input"
      render :new
    end
  end

  def edit
    authorize!(:access, Action.new(:news, :update))

    @news_entry = NewsEntry.internal.find(params[:id])
  end

  def update
    authorize!(:access, Action.new(:news, :update))

    @news_entry = NewsEntry.internal.find(params[:id])

    if @news_entry.update_attributes(news_entry_params)
      flash[:notice] = 'News entry was successfully updated'

      decorated = News::BaseDecorator.decorate(@news_entry)
      serializer = News::BaseSerializer.new(decorated)
      Services::Broadcaster.broadcast(:news, json: serializer.serialize)

      redirect_to edit_news_path(@news_entry)
    else
      flash[:error] = 'Please check your input'
      render :edit
    end
  end

  def destroy
    authorize!(:access, Action.new(:news, :delete))

    @news_entry = NewsEntry.internal.find(params[:id])

    if @news_entry.destroy
      decorated = News::BaseDecorator.decorate(@news_entry)
      serializer = News::BaseSerializer.new(decorated)
      Services::Broadcaster.broadcast(:news, json: serializer.serialize)

      flash[:notice] = "News entry was successfully deleted"
    else
      flash[:error] = "News entry was not deleted"
    end

    redirect_to :back
  end

  private

  def fetch_news_entries
    fetch_internal_news_entries
    fetch_external_news_entries
  end

  def fetch_internal_news_entries
    internal_news_entries  = NewsEntry.internal.accessible_by(current_user, :read).paginate(pagination_scope)
    @internal_news_entries = NewsEntryDecorator.decorate_collection(internal_news_entries)
  end

  def fetch_external_news_entries
    external_news_entries  = NewsEntry.external.accessible_by(current_user, :read).paginate(pagination_scope)
    @external_news_entries = NewsEntryDecorator.decorate_collection(external_news_entries)
  end

  # Returns maximum total count of news entries groupped by type
  def get_max_total_count
    result = ActiveRecord::Base.connection.execute(
      "select count(*) as max_total_count from news_entries group by news_type order by count(*) desc limit 1"
    ).first
    (result && result["max_total_count"]) || 0
  end

  def news_entry_params
    params.require(:news_entry).permit(:title, :body)
  end

  def service
    ::Services::NewsEntries.new(as: current_user)
  end
end
