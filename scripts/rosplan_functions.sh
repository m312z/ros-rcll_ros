#!/bin/bash

rosplan_add_instances()
{
	INSTANCES="$@"
	IFS=" "
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
}

rosplan_add_facts()
{
	FACTS="$@"
	IFS=" "
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
}

rosplan_add_goals()
{
	GOALS="$@"
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
}

rosplan_clear_all()
{
	# Clear everything
	rostopic pub -1 /kcl_rosplan/planning_commands std_msgs/String "cancel"
	rosservice call /kcl_rosplan/clear_knowledge_base
}

rosplan_call_planner()
{
	#rosservice call /kcl_rosplan/planning_server
	rostopic pub -1 /kcl_rosplan/planning_commands std_msgs/String "plan"
}
