import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> _itemList = List<int>.generate(60, (index) => index);

  List<dynamic>? jsonList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async{
    http.Response response = await http.get(Uri.parse("https://protocoderspoint.com/jsondata/superheros.json"));
    if(response.statusCode == 200){
      setState(() {
        var newData = json.decode(response.body);
        jsonList = newData['superheros'];
      });
    }else{
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordable'),
      ),
      body: _reordarableListFromHttp(),
    );
  }

  ReorderableListView _reorderableListView() {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final int temp = _itemList[oldIndex];
          _itemList.removeAt(oldIndex);
          _itemList.insert(newIndex, temp);
        });
        print(_itemList);
      },
      children: [
        for (int index = 0; index < _itemList.length; index++)
          ListTile(
            key: Key('$index'),
            title: Text('Item ${_itemList[index]}'),
          )
      ],
    );
  }

  Widget _reorderableListViewBuilder() {
    return ReorderableListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            key: Key('${index}'),
            child: ListTile(
              title: Text('Item ${_itemList[index]}'),
            ),
          );
        },
        itemCount: _itemList.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final int tmp = _itemList[oldIndex];
            _itemList.removeAt(oldIndex);
            _itemList.insert(newIndex, tmp);
          });
        });
  }

  Widget _reordarableListFromHttp() {
    print("List Count: ${jsonList?.length}");
    return ReorderableListView.builder(
        itemBuilder: (BuildContext context,int index){
          return Card(
            key: Key('${index}'),
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    jsonList?[index]['url'],
                    fit: BoxFit.fill,
                    width: 50,
                    height: 100,
                  )
              ),
              title: Text(jsonList?[index]['name']),
              subtitle: Text(jsonList?[index]['power'],maxLines: 4,),
            ),
          );
        },
        itemCount: jsonList?.length ?? 0,
        onReorder: (int oldIndex,int newIndex){
          setState(() {
            if(newIndex > oldIndex){
              newIndex -=1;
            }
            final tmp = jsonList?[oldIndex];
            jsonList?.removeAt(oldIndex);
            jsonList?.insert(newIndex, tmp);
          });
        });
  }

}
