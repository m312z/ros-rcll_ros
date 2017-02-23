#!/bin/bash

source $(dirname $(realpath $0))/rosplan_functions.sh

TEAM_PREFIX="C"
MPS="BS CS1 CS2 DS"
ROBOTS="R-1 R-2 R-3"
WORKPIECES="wp1"
#CAP_CARRIERS_GREY="cg1-LEFT cg2-MIDDLE cg3-RIGHT"
CAP_CARRIERS_BLACK="cb1-LEFT cb2-MIDDLE cb3-RIGHT"

INSTANCES="CYAN:team-color"
FACTS="location-free;l:START|side:ANYSIDE"

for M in $MPS; do
		TM="${TEAM_PREFIX}-$M"
		# This is done by rosplan_kb_updater_machine_info
		#INSTANCES="$INSTANCES $TM:mps"
		#FACTS="$FACTS mps-type;m:$TM|t:${M:0:2}"
		FACTS="$FACTS location-free;l:$TM|side:INPUT location-free;l:$TM|side:OUTPUT"
		FACTS="$FACTS location-allowed;l:$TM"
done
for R in $ROBOTS; do
		INSTANCES="$INSTANCES $R:robot"
		FACTS="$FACTS robot-waiting;r:$R"
done
for W in $WORKPIECES; do
		INSTANCES="$INSTANCES $W:workpiece"
		FACTS="$FACTS wp-base-color;wp:$W|col:BASE_NONE"
		FACTS="$FACTS wp-cap-color;wp:$W|col:CAP_NONE"
		FACTS="$FACTS wp-ring1-color;wp:$W|col:RING_NONE"
		FACTS="$FACTS wp-ring2-color;wp:$W|col:RING_NONE"
		FACTS="$FACTS wp-ring3-color;wp:$W|col:RING_NONE"
		FACTS="$FACTS wp-unused;wp:$W"
done
for C in $CAP_CARRIERS_GREY; do
		INSTANCES="$INSTANCES ${C%%-*}:cap-carrier"
		FACTS="$FACTS wp-base-color;wp:${C%%-*}|col:BASE_CC"
		FACTS="$FACTS wp-cap-color;wp:${C%%-*}|col:CAP_GREY"
		FACTS="$FACTS wp-on-shelf;wp:${C%%-*}|m:C-CS1|spot:${C##*-}"
done
for C in $CAP_CARRIERS_BLACK; do
		INSTANCES="$INSTANCES ${C%%-*}:cap-carrier"
		FACTS="$FACTS wp-base-color;wp:${C%%-*}|col:BASE_CC"
		FACTS="$FACTS wp-cap-color;wp:${C%%-*}|col:CAP_BLACK"
		FACTS="$FACTS wp-on-shelf;wp:${C%%-*}|m:C-CS2|spot:${C##*-}"
done

FACTS="$FACTS cs-can-perform;m:C-CS1|op:CS_RETRIEVE cs-can-perform;m:C-CS2|op:CS_RETRIEVE"
FACTS="$FACTS cs-free;m:C-CS1 cs-free;m:C-CS2"

# C0 order
INSTANCES="$INSTANCES o1:order"
FACTS="$FACTS order-complexity;ord:o1|com:c0"
FACTS="$FACTS order-base-color;ord:o1|col:BASE_BLACK"
FACTS="$FACTS order-cap-color;ord:o1|col:CAP_BLACK"

GOALS="order-fulfilled;ord:o1"

rosplan_clear_all
rosplan_add_instances $INSTANCES
rosplan_add_facts $FACTS
rosplan_add_goals $GOALS
rosplan_call_planner
