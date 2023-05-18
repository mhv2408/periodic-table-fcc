#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#echo -e "\n~~~Periodic Table ~~~\n"
#if no argument is provided
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi
#if the input is number
if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number='$1'")
#if the input is string
else
  element=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1' or symbol='$1'")
fi
#if the element is not in the database
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi
#print the result
echo $element | while IFS=" |" read atomic_number element symbol type mass mp bp
do
  echo -e "The element with atomic number $atomic_number is $element ($symbol). It's a $type, with a mass of $mass amu. $element has a melting point of $mp celsius and a boiling point of $bp celsius."
done
