
# netns Creater and Connector

This script creates a network namespace and then with the help of the veth, it connects our freshly created namespace into a new linux bridge. With the help of the this script we will be able to access multiple groups of network namespaces through the linux bridges. Script adds a single namespace in every single runtime. We need to specify 4 different variables in order to make it work.

## Role Variables

| Variable             | Required | Default | Location                  | Comments                             |
| -------------------- | -------- | ------- | ------------------------- | ------------------------------------ |
| NAME                 | yes      |         | $1                        | Name of the new netns                |
| NAMESPACE_IP         | yes      |         | $2                        | IP of the netns,don't forget subnet  |
| BRIDGE_NAME          | yes      |         | $3                        | Name of the bridge                   |
| BRIDGE_IP            | yes      |         | $4                        | IP of the bridge,don't forget subnet |

## Example Command
./netnsConnector.sh namespace1 15.4.0.11/24 br1 15.4.0.10/24 && \
./netnsConnector.sh namespace2 15.4.0.12/24 br1 15.4.0.10/24 && \
./netnsConnector.sh namespace3 15.4.0.13/24 br1 15.4.0.10/24

Now this three namespaces are able to communicate with each others.
