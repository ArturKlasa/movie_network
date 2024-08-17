import 'dart:collection';

class Friend {
  String name;
  List<String> movies = [];
  List<Friend> friends = [];

  Friend(this.name);

  void addMovie(String movie) {
    movies.add(movie);
  }

  void addFriend(Friend friend) {
    friends.add(friend);
  }
}

class FriendsNetwork {
  Map<String, Friend> friendsMap = {};

  void addToFriends(String name) {
    if (!friendsMap.containsKey(name)) {
      friendsMap[name] = Friend(name);
    }
  }

  void addConnection(String friend1, String friend2) {
    if (friendsMap.containsKey(friend1) && friendsMap.containsKey(friend2)) {
      friendsMap[friend1]!.addFriend(friendsMap[friend2]!);
      friendsMap[friend2]!.addFriend(friendsMap[friend1]!);
    }
  }

  void addMovie(String person, String movie) {
    if (friendsMap.containsKey(person)) {
      friendsMap[person]!.addMovie(movie);
    }
  }

  String? mostPopularMovie(String person) {
    if (!friendsMap.containsKey(person)) {
      return null;
    }

    var visited = <Friend>{};
    var queue = Queue<Friend>();
    var movieCount = <String, int>{};

    queue.add(friendsMap[person]!);

    while (queue.isNotEmpty) {
      var currentPerson = queue.removeFirst();
      if (visited.contains(currentPerson)) {
        continue;
      }

      visited.add(currentPerson);

      for (var movie in currentPerson.movies) {
        movieCount[movie] = (movieCount[movie] ?? 0) + 1;
      }

      for (var friend in currentPerson.friends) {
        if (!visited.contains(friend)) {
          queue.add(friend);
        }
      }
    }

    String? mostPopular;
    int maxCount = 0;

    movieCount.forEach((movie, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopular = movie;
      }
    });

    return mostPopular;
  }
}

// Test case for the happy path
void testMostPopularMovie(String name) {
  var network = FriendsNetwork();
  network.addToFriends('Mark');
  network.addToFriends('Greg');
  network.addToFriends('Gabe');
  network.addToFriends('Daniel');
  network.addToFriends('Monica');

  network.addConnection('Gabe', 'Monica');
  network.addConnection('Gabe', 'Mark');
  network.addConnection('Greg', 'Daniel');
  network.addConnection('Mark', 'Monica');

  network.addMovie('Mark', 'The Shawshank Redemption');
  network.addMovie('Mark', 'The Godfather');
  network.addMovie('Greg', 'The Dark Knight');
  network.addMovie('Greg', 'The Shawshank Redemption');
  network.addMovie('Gabe', 'The Godfather');
  network.addMovie('Gabe', 'The Dark Knight');
  network.addMovie('Daniel', 'The Shawshank Redemption');
  network.addMovie('Monica', 'The Godfather');
  network.addMovie('Monica', 'The Dark Knight');

  var result = network.mostPopularMovie(name);
  print(result); // Expected output: 'The Shawshank Redemption'
}

void main() {
  testMostPopularMovie('Mark');
}
