class GenerateFontAwesomeIcons < PMIPAction
  def run(event, context)
    url = "http://fortawesome.github.io/Font-Awesome/cheatsheet/"
    output = 'src/main/scala/jetboot/fontawesome/Icons.scala'

    #TODO: get this from intellij settings
    username = "????????"
    password = "????????"
    proxy_host = '????????'
    proxy_port = '80'

    r = open(url, :proxy => "http://#{username}:#{password}@#{proxy_host}:#{proxy_port}/").read.
        split.select{|l| l.strip.start_with?('icon-') }.reject{|l| l.include?('&nbsp;') }

    content = ['//TIP: this file is generated, do not edit', 'object Icons {']
    r.each{|i| content << "\tval #{camel_case(i.sub('icon-', ''))} = \"#{i}\"" }
    content << '}'

    context.filepath_from_root(output).writelines(content)

    result_and_balloon("Font Awesome icons were written to #{output}")
  end

  private

  def camel_case(s)
    return s if s !~ /-/ && s =~ /[A-Z]+.*/
    s.split('-').map{|e| e.capitalize}.join
  end
end