#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to my Beauty Bar, how can I help you?"

SERVICE_LIST(){
   if [[ $1 ]]
   then
    echo -e "\n$1"
   fi
  
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
   
   if [[ -z $AVAILABLE_SERVICES ]]
   then
    echo -"Sorry, we don't have that service at the moment"
    else
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
    echo "$SERVICE_ID) $NAME"
    done
   fi
    read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
     then
     SERVICE_LIST " That is not a number"
     else
     SERV_AVAIL=$($PSQL " SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED ")
     if [[ ! $SERV_AVAIL ]]
      then
       SERVICE_LIST " I could not find that service. What would you like today?"
       else
       SERV_NAME=$($PSQL " SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED ") 
       echo -e "What's your phone number?"
       read CUSTOMER_PHONE
       CUSTOMER_NAME=$($PSQL "SELECT name FROM  customers WHERE phone ='$CUSTOMER_PHONE' ")
       if [[ -z $CUSTOMER_NAME ]]
       then
         echo - "What is your name?"
         read CUSTOMER_NAME
         INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

    fi
    echo "What time would you like your appointment to be at $SERV_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ $SERVICE_TIME ]]
    then
     INSERT_SERV_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time)VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
     if [[ $INSERT_SERV_RESULT ]]
     then
     echo -e "\nI have put you down for a $SERV_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  
     fi
   fi
  fi
fi
}
SERVICE_LIST