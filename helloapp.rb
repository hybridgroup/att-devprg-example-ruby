require 'rubygems'
require 'sinatra'
require 'oauth2' 
require 'json'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def client
  OAuth2::Client.new((ENV['CLIENT_ID']||'testing'),
                     (ENV['CLIENT_SECRET']||'testing'),
                     :site => ENV['AUTH_SERVER'],
                     :authorize_url => "#{ENV['AUTH_SERVER']}/oauth/authorize",
                     :token_url => "#{ENV['AUTH_SERVER']}/oauth/token")
end

def api_url
  ENV['API_SERVER'] || "#{ENV['AUTH_SERVER']}/me.json"
end

def scope
  ENV['SCOPE'] || "profile"
end

get "/" do
  erb :index
end

get '/auth' do
  authorization_url = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :response_type => "code", :scope => scope)
  puts "Redirecting to URL: #{authorization_url.inspect}"
  redirect authorization_url
end

get '/auth/callback' do
  begin
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    if ENV['JSON'] == "1"
      data = JSON.parse(access_token.get(api_url).body)
    else
      data = access_token.get(api_url).body
    end

    erb "<p>Your data:\n#{data.inspect}</p>"
  rescue OAuth2::Error => e
    erb %(<p>#{$!}</p><p><a href="/auth">Retry</a></p>)
  end
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

def redirect_uri(path = '/auth/callback', query = nil)
  uri = URI.parse(request.url)
  uri.path  = path
  uri.query = query
  uri.to_s
end

__END__
@@ index
<form action="/auth">
  <input type="submit" value="Test" />
<form>

@@ layout

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>AT&T Developer Program - Example App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Le styles -->
    <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
  </head>

  <body>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="/">AT&T Developer Program - Example App</a>
        </div>
      </div>
    </div>

    <div class="container">
      <%= yield %>
    </div> <!-- /container -->
  </body>
</html>
