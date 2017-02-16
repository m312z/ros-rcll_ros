#!/bin/bash

source $(dirname $(realpath $0))/rosplan_functions.sh

INSTANCES="C-BS:mps C-DS:mps C-CS1:mps C-CS2:mps C-RS1:mps C-RS2:mps"
FACTS="mps-type;m:C-BS|t:BS mps-type;m:C-DS|t:DS mps-type;m:C-CS1|t:CS mps-type;m:C-CS2|t:CS mps-type;m:C-RS1|t:RS mps-type;m:C-RS2|t:RS"
GOALS="prepared;m:C-BS prepared;m:C-DS prepared;m:C-CS1 prepared;m:C-CS2 prepared;m:C-RS1 prepared;m:C-RS2"

rosplan_clear_all
rosplan_add_instances $INSTANCES
rosplan_add_facts $FACTS
rosplan_add_goals $GOALS
rosplan_call_planner
