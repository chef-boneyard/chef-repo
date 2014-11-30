actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "cron"

attribute :minute, :kind_of => [Integer, String], :default => "*"
attribute :hour, :kind_of => [Integer, String], :default => "*"
attribute :day, :kind_of => [Integer, String], :default => "*"
attribute :month, :kind_of => [Integer, String], :default => "*"
attribute :weekday, :kind_of => [Integer, String], :default => "*"

attribute :command, :kind_of => String, :required => true

attribute :user, :kind_of => String, :default => "root"

attribute :mailto, :kind_of => [String, NilClass]
attribute :path, :kind_of => [String, NilClass]
attribute :home, :kind_of => [String, NilClass]
attribute :shell, :kind_of => [String, NilClass]

def initialize(*args)
  super
  @action = :create
end
