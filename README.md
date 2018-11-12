# Recommendation Engine

## Description
This is a simple proof of concept demonstrating the calculations necessary to create a basic recommendation engine. This proof uses information about which products users have liked and disliked to derive similarity indexes representing the degree of taste similarity between each set of users. It then uses these similarity indexes in combination with the like/dislike history of the compared users to determine which new products any given user is most likely to enjoy.

## Project Setup

* `bundle install`
* `bundle exec rake db:setup`
* `bundle exec rake db:migrate`
* `bundle exec rake db:seed`
* `rails s`

The seed file creates users, products, and an initial set of random likes and dislikes. To generate and/or update similarity and likeability indexes based on that data, you can run the following commands in the console:

* `RecommendationService.update_all_similarity_indexes`
* `RecommendationService.update_all_likeability_indexes`

To view results, make sure the server is running and go to `localhost:3000`