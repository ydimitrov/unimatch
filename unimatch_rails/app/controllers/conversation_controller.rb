class ConversationController < ApplicationController
    #used for conversations with other users
    def show
        @con = Conversation.find(params[:id])
        
        if !@con.is_member?(User.find(session[:user_id]))
            flash[:warning] = "YOU DONT GET TO DO THAT"
            redirect_to root_path
        end
        
        @msgs = @con.get_messages
        
        @msgs = @msgs.sort_by { |msg| msg.created_at }
        @newest_message = @msgs.length > 0 ? @msgs[-1].created_at.to_json.html_safe : DateTime.now.to_json.html_safe
        
        @conusers = @con.get_users
        
        @users = {}
        @users[@conusers[0].id] = @conusers[0]
        @users[@conusers[1].id] = @conusers[1]
        
        @message = Message.new()
        
        @con.seen_by(session[:user_id])
        
		respond_to do |format|
			format.html { 
			    if @conusers.length == 2
			       target = if @conusers[0] != User.find(session[:user_id]) then @conusers[0] else @conusers[1] end

			       redirect_to user_path(target.id)
			    end
			}
			
			format.json {
				render json: @msgs
			}
	    end
        
    end#shows you conversation with the user, uses get messages function below
    
    def get_messages
        @con = Conversation.find(params[:id])
        
        @msgs = []
        
        if (params[:last].nil?)
            @msgs = @con.get_messages_limit(params[:from], params[:to])
        else
            time = params[:last].to_f / 1000.0
            puts time
            time = Time.at(time)
            puts "PARAMS LAST: " + time.to_s
            @msgs = @con.get_messages_newer(time)
        end
        
        @users = {}
        
        @con.get_users.each do |u|
            @users[u.id] = User.find(u.id)
        end
        
        @temp = []
        @msgs.each do |msg|
            m = {}
            sender = @users[msg.sender_id]
            m[:body] = msg.body
            m[:sender] = sender.name + " " + sender.surname
            m[:sender_id] = sender.id
            m[:date] = msg.created_at
            m[:own] = msg.sender_id.to_i == session[:user_id]
            m[:img] = User.find(msg.sender_id).avatar_url(:display)
            @temp << m
        end
        @msgs = @temp
        
        respond_to do |format|
            format.json {
                render json: @msgs.to_json.html_safe
            }
        end
    end#returns all the messages between you and the other user
    
    #messaging view - create conversation and redirect to show
    def message
        @user1 = User.find(session[:user_id])
        @user2 = User.find(params[:id])
        
        @con = Conversation.find_conversation(@user1, @user2)
        
        if @con.nil?
           @con = Conversation.create_between(@user1, @user2)
        end
        
        redirect_to :action => :show, :id => @con.id
    end#if no conversation between you and the other user it creates one
    
    def create_message
        @message = Message.new()
        
        @user = User.find(session[:user_id])
        @con = Conversation.find(params[:conversation_id])
        
        if !@con.is_member?(@user)
            flash[:warning] = "YOU DONT GET TO DO THAT"
            redirect_to root_path
            return
        end
        
        @message.body = params[:body]
        @message.conversation_id = @con.id
        @message.sender_id = @user.id
        @message.save
        render :body => nil
    end#creates the messages, with appropriate parameters
    
    
end
    