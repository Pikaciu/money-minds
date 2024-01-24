import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Future<List<Map<String, dynamic>>> getKidLeaderboard() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'kid')
          // .orderBy('coins',
          //     descending: true) // Order by coins in descending order
          .get();

      print(querySnapshot);
      print("querySnapshot");

      // Extract data from querySnapshot
      List<Map<String, dynamic>> leaderboardData = querySnapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'email': doc['email'],
                'gender': doc['gender'],
                'coins': doc['coins']
              })
          .toList();
      return leaderboardData;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: FutureBuilder(
        future: getKidLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> leaderboardData =
                snapshot.data as List<Map<String, dynamic>>;
            print(snapshot.data);
            print('snapshot.data');
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                // columnSpacing: 10.0,
                // dataRowHeight: 40.0,
                columns: [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  DataColumn(
                      label: Text('Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))),
                  DataColumn(
                      label: Text('Gender',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))),
                  DataColumn(
                      label: Text('Coins',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))),
                ],
                rows: leaderboardData
                    .map(
                      (data) => DataRow(
                        cells: [
                          DataCell(Text(data['name'] ?? '')),
                          DataCell(Text(data['email'] ?? '')),
                          DataCell(Text(data['gender'] ?? '')),
                          DataCell(Text(data['coins'].toString() ?? '')),
                          // DataCell(Text('abc')),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
