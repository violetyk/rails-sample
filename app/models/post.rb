class Post < ActiveRecord::Base
  validates :title, presence: {
    message: 'を入力してください'
  }
  validates :body, presence: {
    message: 'を10文字以上入力してください'
  },
  length: {
    minimum: 10,
    message: 'を10文字以上入力してください'
  }
end
