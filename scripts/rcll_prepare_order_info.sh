#!/bin/bash

source $(dirname $(realpath $0))/rosplan_functions.sh
INSTANCES="RING_BLUE:Color RING_GREEN:Color RING_ORANGE:Color RING_YELLOW:Color BASE_RED:Color BASE_BLACK:Color BASE_SILVER:Color CAP_BLACK:Color CAP_GREY:Color c0:OrderComplexity c1:OrderComplexity c2:OrderComplexity c3:OrderComplexity"
FACTS=""
GOALS=""

rosplan_clear_all
rosplan_add_instances $INSTANCES
rosplan_add_facts $FACTS
rosplan_add_goals $GOALS
rosplan_call_planner
