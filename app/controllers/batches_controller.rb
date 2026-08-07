class BatchesController < BaseController
  before_action :set_batch, only: %i[show edit update destroy]

  def index
    authorize :batch
    @visible_buckets = Batch.buckets.except('archive').keys
    @batches = Batch.where.not(bucket: :archive).includes(:contacts).order(:name).to_a
    @batches_by_bucket = @batches.group_by(&:bucket)

    @first = @batches_by_bucket['dormant'] || []
    @second = @batches_by_bucket['broad_buying_window'] || []
    @third = @batches_by_bucket['buying_window'] || []
    @fourth = @batches_by_bucket['conversations'] || []
    @fifth = @batches_by_bucket['meetings'] || []
    @sixth = @batches_by_bucket['contracts'] || []

    if params[:batch_id].present?
      @batch = Batch.find(params[:batch_id])
      @contacts = @batch.contacts.includes(:batches_contacts).where('contacts.archived=?',
                                                                    false).order('batches_contacts.created_at DESC').uniq || []
    end

    return unless params[:batch_id].present? && params[:contact_id].present?

    @contact = Contact.find(params[:contact_id])
  end

  def show
    authorize :batch
    @batch = Batch.find(params[:id])
  end

  def new
    authorize :batch
    @batch = Batch.new(bucket: Batch.buckets.except('archive').keys.first)
  end

  def edit
    authorize @batch
  end

  def create
    authorize :batch
    @batch = Batch.new(batch_params)
    respond_to do |format|
      if @batch.save
        Event.create(user: current_user, action: 'group', action_for_context: 'created a group named',
                     trackable: @batch)
        format.turbo_stream { redirect_to batches_path(batch_id: @batch.id), notice: 'Group was created successfully.' }
        format.html { redirect_to batches_path(batch_id: @batch.id), notice: 'Group was created successfully.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(Batch.new, partial: 'batches/form', locals: { batch: @batch })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @batch
    respond_to do |format|
      if @batch.update(batch_params)
        Event.where(trackable: @batch).touch_all
        format.turbo_stream { redirect_to batches_path(batch_id: @batch.id), notice: 'Group was updated successfully.' }
        format.html { redirect_to batches_path(batch_id: @batch.id), notice: 'Group was updated successfully.' }
      else
        format.turbo_stream { redirect_to edit_batch_path(@batch), alert: 'Group was not updated successfully.' }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def contacts
    authorize :batch
    @batch = Batch.find(params[:batch_id])
  end

  def add
    authorize :batch
    @batch = Batch.find(params[:batch_id])
    @contact = Contact.find(params[:id])
    AddContactToGroup.call(@batch, current_user, @contact).result
    redirect_to batches_path(batch_id: @batch.id, contact_id: @contact.id), notice: 'Contact was successfully added.'
  end

  def remove
    authorize :batch
    @contact = Contact.find(params[:id])
    @batch = Batch.find(params[:batch_id])

    RemoveContactFromGroup.call(@batch, current_user, @contact).result
    redirect_to batches_path(batch_id: @batch.id), notice: 'Contact was successfully removed.'
  end

  def destroy
    authorize :batch
    DestroyGroup.call(current_user, @batch).result
    redirect_to batches_path, notice: 'Group was successfully destroyed.'
  end

  private

  def set_batch
    @batch ||= Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:name, :website, :jobboard, :about, :bucket, :linkedin, :twitter, :country, :city,
                                  :state, :address, :timezone, :people_count)
  end
end
