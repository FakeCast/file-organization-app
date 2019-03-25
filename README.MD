# File Organisation Trial
In this project, I chose Sinatra framework to develop the application.
In my opinion, the features provided by the API looks like a microservice and Sinatra is the perfect framework to achieve better results because it don't need to load the middleware applications like in Rails API and can be developed using a single page.
I chose the Rspec as the tests framework because in my opinion using DSL make the tests much more easy to understand.

### Requiremts
Ruby 2.6.2  
Bundler 1.17.2  
MongoDB 3.6.3  

### Gems
Sinatra (Framework) - http://sinatrarb.com/  
Sinatra-Contrib (Allow Namespaces)  
Rspec (Tests) - http://rspec.info/  
Rack-Test (Used to tests the app endpoints) - https://github.com/rack-test/rack-test  
Mongoid - (Database) - https://docs.mongodb.com/mongoid/current/  
```
gem 'sinatra'
gem 'sinatra-contrib'
gem 'mongoid'
group :test do
    gem 'rspec'
    gem 'rack-test'
end
```
## How to use:
### Outside container
1 - Run the following commands  
Configure the ```mongoid.config``` file with the DB server details.  
2 - Run the following commands  
```
bundle
ruby app.rb
```
### Using docker  
1- Install docker composer  
```
apt install docker-compose
```
2- Run the following commands  
```
sudo docker-compose build
sudo docker-compose up
```

### Tests
To run the tests, execute the following command  
```
rspec spec/app.rb --format=doc
```
I do prefer the '--format=doc' parameter to see what is going on in each test.  

### Time Spent
I spent 4 hours on Saturday coding and 2 hours on Monday to review and finish the tests.  
