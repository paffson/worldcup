#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"
# echo -e "\nTotal number of goals in all games from winning teams:"
# echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

A="$($PSQL "truncate table games, teams")"
# Read the first line (header) into an array
read -ra COLUMN_NAMES < games.csv

# Process the data rows (skip the first row)
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    RESULT1=$($PSQL "insert into teams(name) values ('$WINNER')")
  fi
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    RESULT2=$($PSQL "insert into teams(name) values ('$OPPONENT')")
  fi
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  RESULT=$($PSQL "insert 
  into games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) 
  values ($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")
done

# cat games.csv | tail -n +2 | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# do

# done