class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  # GET /programs
  def index
    episodes = Episode
                  .select('programs.*, COUNT(media.id) AS media_count, MAX(media.created_at) AS latest_media')
                  .joins(:media)
                  .group('programs.id')
  end

  # GET /programs/1
  def show
  end

  # # GET /programs/new
  # def new
  #   @program = Program.new
  # end
  #
  # # GET /programs/1/edit
  # def edit
  # end
  #
  # # POST /programs
  # def create
  #   @program = Program.new(program_params)
  #
  #   if @program.save
  #     redirect_to @program, notice: 'Program was successfully created.'
  #   else
  #     render :new
  #   end
  # end
  #
  # # PATCH/PUT /programs/1
  # def update
  #   if @program.update(program_params)
  #     redirect_to @program, notice: 'Program was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /programs/1
  def destroy
    episode.destroy
    redirect_to episodes_path, notice: 'Episode was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def episode_params
      params.fetch(:episode, {})
    end
end
