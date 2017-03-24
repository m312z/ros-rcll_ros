#!/bin/bash

# Note that this script is no longer necessary using rosplan_initial_situation.
# It is here as a reference should you prefer writing a (dynamic) script

source $(dirname $(realpath $0))/rosplan_functions.sh

INSTANCES="C-BS-I:machine C-DS-I:machine C-CS1-I:machine C-CS2-I:machine C-RS1-I:machine C-RS2-I:machine R-1:robot CYAN:team-color"
#FACTS="at;r:R-1|m:S"
FACTS="free-location;l:START free-location;l:C-BS-I free-location;l:C-DS-I free-location;l:C-CS1-I free-location;l:C-CS2-I free-location;l:C-RS1-I free-location;l:C-RS2-I robot-waiting;r:R-1"
GOALS="visited;m:C-BS-I visited;m:C-DS-I visited;m:C-CS1-I  visited;m:C-CS2-I visited;m:C-RS1-I visited;m:C-RS2-I"

rosplan_clear_all
rosplan_add_instances $INSTANCES
rosplan_add_facts $FACTS
rosplan_add_goals $GOALS
rosplan_call_planner
