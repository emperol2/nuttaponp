require 'net/pop' # I renamed the file from pop.rb to pop_ssl.rb to ensure I was requiring the correct version

username = 'manchuwokhr@gmail.com'
password = 'manchuwokhr!!!'

Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
Net::POP3.start('pop.gmail.com', 995, username, password) do |pop|
  if pop.mails.empty?
    puts 'No mail.'
  else
    pop.each_mail do |mail|
      #p mail.header
      p mail.pop
    end
  end
end