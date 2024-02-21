#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE=$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR = 'year' ]]
  then
    WIN_CHECK=$($PSQL "Select name from teams where name = '$WINNER'")
    OPP_CHECK=$($PSQL "Select name from teams where name = '$OPPONENT'")
    if [[ -z $WIN_CHECK ]]
      then
        echo "$($PSQL "Insert into teams(name) VALUES('$WINNER')")"
      elif [[ -z $OPP_CHECK ]]
      then
        echo "$($PSQL "Insert into teams(name) VALUES('$OPPONENT')")"
    fi 
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR = 'year' ]]
  then
    WINNER_ID=$($PSQL "Select team_id from teams where name = '$WINNER'")
    OPP_ID=$($PSQL "Select team_id from teams where name = '$OPPONENT'")

    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPP_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")"
  fi
done
