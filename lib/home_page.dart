import 'dart:convert';
import 'package:belajar_flutter/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  Future<List<dynamic>> _fecthDataUsers() async {
    var url = Uri.parse('https://reqres.in/api/users?per_page=20');
    var result = await http.get(url);
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: VColor.primaryColors,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                    'Welcome,',
                    style: TextStyle(fontSize: 16, color: VColor.black, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _fecthDataUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: 7.0 / 9.0,
                        children: List.generate(snapshot.data.length, (index) {
                          return buildGridCards(context, index, snapshot);
                        })
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildGridCards(BuildContext context, int index,AsyncSnapshot snapshot) {
  return Container(
    padding: const EdgeInsets.all(5),
    child: Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Image.network(
              snapshot.data[index]['avatar'],
              height: 170,
              fit: BoxFit.fill
          ),
          const SizedBox(height: 10.0),
          Column(
            children: [
              Text(snapshot.data[index]['first_name'] + " " + snapshot.data[index]['last_name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5.0),
              Text(snapshot.data[index]['email'],style: const TextStyle(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    ),
  );
}