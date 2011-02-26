require 'ucb_ldap'

username = 'uid=eecs_vdms,ou=applications,dc=berkeley,dc=edu'
password = 'wh3nsth3mtg?'

UCB::LDAP.authenticate(username, password) if RAILS_ENV=='production'
