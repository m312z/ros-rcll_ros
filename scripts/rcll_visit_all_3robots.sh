#!/bin/bash

echo "Creating base instances"

INSTANCES="S:location S2:location S3:location INS:location C-BS-I:machine C-DS-I:machine C-CS1-I:machine C-CS2-I:machine C-RS1-I:machine C-RS2-I:machine R-1:robot R-2:robot R-3:robot CYAN:team-color"
FACTS="at;r:R-1|m:S at;r:R-2|m:S2 at;r:R-3|m:S3"
GOALS="visited;m:C-BS-I visited;m:C-DS-I visited;m:C-CS1-I  visited;m:C-CS2-I visited;m:C-RS1-I visited;m:C-RS2-I"

# Clear everything
rostopic pub -1 /kcl_rosplan/planning_commands std_msgs/String "cancel"
rosservice call /kcl_rosplan/clear_knowledge_base

for i in $INSTANCES; do
	echo "Adding instance ${i%%:*} of type ${i##*:}"
	rosservice call /kcl_rosplan/update_knowledge_base "update_type: 0
knowledge:
  knowledge_type: 0
  instance_type: '${i##*:}'
  instance_name: '${i%%:*}'
  attribute_name: ''
  function_value: 0.0";
done

for f in $FACTS; do
  PREDNAME=${f%%;*}
  ARGS=${f##*;}
  MSG="update_type: 0
knowledge:
  knowledge_type: 1
  instance_type: ''
  instance_name: ''
  function_value: 0.0
  attribute_name: '${PREDNAME}'
  values:"

	echo -n "Fact ($PREDNAME"
  IFS="|"; for a in $ARGS; do
    MSG="$MSG
  - {key: '${a%%:*}', value: '${a##*:}'}"
		echo -n " ?${a%%:*}=${a##*:}"
	done
  echo ")"
  rosservice call /kcl_rosplan/update_knowledge_base "$MSG"
done

IFS=" "
for g in $GOALS; do
  PREDNAME=${g%%;*}
  ARGS=${g##*;}
  MSG="update_type: 1
knowledge:
  knowledge_type: 1
  instance_type: ''
  instance_name: ''
  function_value: 0.0
  attribute_name: '${PREDNAME}'
  values:"

	echo -n "Goal ($PREDNAME"
  IFS="|"; for a in $ARGS; do
    MSG="$MSG
  - {key: '${a%%:*}', value: '${a##*:}'}"
		echo -n " ?${a%%:*}=${a##*:}"
	done
  echo ")"
  rosservice call /kcl_rosplan/update_knowledge_base "$MSG"
done

# Call planner
# rosservice call /kcl_rosplan/planning_server

