class Report::BatchesController < Report::BaseController
  def index
    authorize :report

    @filters = BatchFilter.new(group_filter_params)
    @batches = Batch.query(group_filter_params)
    render_partial('report/groups/group', collection: @batches, cached: false)
  end

  private

  def group_filter_params
    params.permit(*BatchFilter::KEYS)
  end
end
