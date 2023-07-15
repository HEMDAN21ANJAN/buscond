import 'package:busti007/screens/route_name.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:busti007/screens/route_details.dart';


class RouteManagement extends StatefulWidget {
  final String busID;

  RouteManagement({required this.busID});

  @override
  _RouteManagementState createState() => _RouteManagementState();
}

class _RouteManagementState extends State<RouteManagement> {
  void _addRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRoutePage(busID: widget.busID)),
    );
  }

  void _viewRouteDetails(String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RouteDetailsPage(routeName: routeName)),
    );
  }

  void _deleteRoute(String routeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this route?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('conductors')
                  .doc(widget.busID)
                  .collection('routes')
                  .doc(routeId)
                  .delete();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Management'),
        actions: [
          FloatingActionButton(
            onPressed: _addRoute,
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conductors')
            .doc(widget.busID)
            .collection('routes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final routes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final routeData = routes[index].data() as Map<String, dynamic>;
                final routeName = routeData['routeName'] as String;
                final routeId = routes[index].id;

                return ListTile(
                  title: Text(routeName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteRoute(routeId),
                  ),
                  onTap: () => _viewRouteDetails(routeName),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
