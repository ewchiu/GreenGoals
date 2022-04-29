//Creating a class to store the Goals data;
class GoalsResponse {
  int count = 0;
  List<Goal> goals = [];

  GoalsResponse(this.count, this.goals);
}

class Goal {
  String category = "";
  String description = "";
  int goalId = 0;
  int points = 0;

  Goal(this.category, this.description, this.goalId, this.points);
}