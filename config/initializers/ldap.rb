require 'ucb_ldap'

username = 'uid=eecs_vdms,ou=applications,dc=berkeley,dc=edu'
password = ''

UCB::LDAP.authenticate(username, password)

