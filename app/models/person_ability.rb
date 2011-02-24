# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
# Portions of code borrowed from Rides app

# Users have one of 3 roles - Faculty, PeerAdvisor, and Staff
#
# STAFF can perform all CRUD operations on every model
#
# FACULTY can only read and update ONE Professor model, his own, like a user manages his avatar.
#   He can also do CRUD on Timeslots under his model, i.e. professor.timeslot.new
# 
# PEERADVISOR can only read and update Students that belong to him.
#   He can also do CRUD on Timeslots under Students that belong to him
#
# CanCan only requires current_user to be defined
=begin
unauthorized! if cannot? :update, @article
load_and_authorize_resource :nested => :article (/articles/comments/)# but that means you can delete all the Model.find_by_id and Model.new's
rescue_from CanCan::AccessDenied do |exception|
  flash[:error] = "Access denied."
  redirect_to root_url
end

<% if can? :update, @issue %>
<%= link_to “Edit Issue”, edit_issue_path(@issue) %>
<% end %>
=end

class PersonAbility
  include CanCan::Ability
  
  def initialize(current_user)
    current_user ||= Person.new
    
    if current_user.class == Staff
      can :manage, :all
      
    elsif current_user.class == Faculty
      can [:read, :update], Faculty, :id => current_user.id
      can :manage, AdmitRanking, :faculty_id => current_user.id
      can :manage, AvailableTime, :schedulable_id => current_user.id
      can :read, Meeting
      
      #[AdmitRanking, AvailableTime].zip([:faculty_id, :schedulable_id]).map do |model, id|
      #  can :create, model
      #  can [:read, :update, :destroy], model, id => current_user.id
      #end
      
    elsif current_user.class == PeerAdvisor
      can :manage, FacultyRanking
      can [:read, :update], Admit
      can :read, Meeting
      can :create, AvailableTime
      can [:read, :update, :destroy], AvailableTime do |available_time|
        Person.find_by_id(available_time.try(:schedulable_id)).try(:class) == Admit
      end

    else
      cannot :manage, :all
    end
    
  end
end
