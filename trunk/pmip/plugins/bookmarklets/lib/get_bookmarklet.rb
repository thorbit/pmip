class GetBookmarklet < PMIPServlet
  def get(request, response, context)
    content_type('text/javascript')
    response.body = replace_includes(@args[:Path], request)
  end

  private

  def replace_includes(path, request)
    original = path.create_filepath(request.path.split('/').last).readlines
    original.collect{|l| l =~ /include\(\'(.*)\'\)/ ? path.parent.create_filepath($1).read : l }.join
  end
end