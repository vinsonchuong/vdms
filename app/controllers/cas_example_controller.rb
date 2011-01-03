require 'calnet_authentication'

class CasExampleController < ApplicationController
  include CalNetAuthentication
  
  def index
    ldap = Net::LDAP.new
    ldap.host = "ldap-test.berkeley.edu"
    filter = Net::LDAP::Filter.eq( "uid", session[:cas_user])
    attrs = []
    
    @ldapparams = Hash.new
    
    ldap.search( :base => "ou=people,dc=berkeley,dc=edu", :filter => filter, :return_result => true ) do |entry|
      
      entry.attribute_names.each do |n|
        @ldapparams[n] = entry[n]
      end
    end
  end
  
end
