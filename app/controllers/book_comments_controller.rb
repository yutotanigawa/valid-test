class BookCommentsController < ApplicationController

	def create
		@user = current_user
		book = Book.find(params[:book_id])
		comment = current_user.book_comments.new(book_comment_params)
		comment.book_id = book.id
		if comment.save
			  flash[:success] = "Comment was successfully created."
		redirect_to book_path(book.id)
		else
		redirect_back(fallback_location: root_path)
		end
  	end


	def destroy
		@book = Book.find(params[:id])
		@comment = @book.book_comments.find(params[:book_id])
		@comment.destroy
		redirect_to book_path(@book.id)
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
