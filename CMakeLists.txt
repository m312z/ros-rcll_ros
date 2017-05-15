cmake_minimum_required(VERSION 2.8.3)
project(rcll_ros)
find_package(catkin REQUIRED)
catkin_package()

# install extra files
install(DIRECTORY launch
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/
)
install(DIRECTORY config
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/
)
install(DIRECTORY pddl
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/
)
