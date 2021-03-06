module ApplicationHelper
  def flash_class(level)
    puts level
    case level
    when 'notice' then "alert alert-info"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-danger"
    else "alert alert-info"
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, admin_media_sermons_path(sort: column, direction: direction, view: 'table'), class: 'text-dark font-weight-500'
  end

  def sort_icon(column)
    return if column != params[:sort]

    if params[:direction] == 'asc'
      content_tag(:i, '', class: 'fas fa-sort-up')
    else
      content_tag(:i, '', class: 'fas fa-sort-down')
    end
  end
end
