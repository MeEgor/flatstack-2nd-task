class Vkontakte
  require 'net/http'
  require 'open-uri'

  attr_reader :user, :errors, :uid
  attr_accessor :code

  @@client_id = 4445461
  @@redirect_uri = 'http://localhost:3000/vk-auth'

  def initialize code = nil
    @acess_token_url = 'https://oauth.vk.com/access_token'
    @get_user_url = 'https://api.vk.com/method/users.get'
    @secret = 'lTJhjBbVnu4ZRNWRvMUr'
    @code = code
    @errors = []
  end

  def load
    access_token
    get_user
  end

  def parse
    @user = {
      :vk_uid => @row_data['uid'],
      :name => "#{@row_data['first_name']} #{@row_data['last_name']}",
    }
    self
  end

  def self.auth_url
    "http://oauth.vk.com/authorize?client_id=#{@@client_id}&redirect_uri=#{@@redirect_uri}&response_type=code"
  end

  private

    def access_token
      if @code
        args = {
          :client_id => @@client_id,
          :client_secret => @secret,
          :code => @code,
          :redirect_uri => @@redirect_uri
        }

        uri = URI.parse(@acess_token_url)
        uri.query = URI.encode_www_form(args)
        http = Net::HTTP.new(uri.host, uri.port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        @access_token = JSON.parse(response.body)
      end
    end

    def get_user

      if @access_token

        args = {
          :uids => @access_token["user_id"],
          :fields => '',
          :access_token => @access_token["access_token"],
        }

        uri = URI.parse(@get_user_url)
        uri.query = URI.encode_www_form(args)
        http = Net::HTTP.new(uri.host, uri.port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        @row_data = JSON.parse(response.body)['response'][0]
        @uid = @access_token["user_id"]
      end
    end
end