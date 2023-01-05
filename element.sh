#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then

  if [[ -z $ELEMENT ]]git
  then
    echo "I could not find that element in the database"
   else
    echo $ELEMENT | while IFS=\ | read ATOMIC_NUMBER ATOMIC_MASS MPC BPC SY NAME TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SY). It's a $TYPE, with a mass of $ATOMIC_MASS amu. Hydrogen has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  done
  
   fi
else
echo "Please provide an element as an argument."
fi