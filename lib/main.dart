import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool apiFired = false;
  List watchList = [];

  @override
  void initState() {
    super.initState();
    apiFired = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Center(child: Text("WatchList")),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        actions: <Widget>[Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(Icons.list),
        )]
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: apiFired?
        ListView.builder(
          itemCount: watchList.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              elevation: 8,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, 0.7),
                ),
                child: ListTile(
                  leading: Text((index + 1).toString() + ".", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height*0.04,)),
                  title: Text(watchList[index]['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(watchList[index]['id'].toString(), style: TextStyle(color: Colors.white)) 
                ),
              ),
            );
          }
        ):
        Center(
          child: InkWell(
            onTap: ()async{
              await fetchApi();
            },
            child: Container(              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightBlue[400],
              ),
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Icon(Icons.api_rounded, color: Colors.white, size: 50),
                Text("Get Watchlist", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 20))
              ],),
            ),
          ),
        )
    );
  }
  fetchApi()async{
    String url = "https://api.stocktwits.com/api/2/watchlists.json?access_token=f8764b90393fd0dee956d649e00f2f291949e93b";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          child: Container(
          height: MediaQuery.of(context).size.height*0.1,
          width: MediaQuery.of(context).size.width*0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(" Loading" , style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20))
              ],
            ),
          ),
        );
      }
    );
    var result = await http.get(Uri.parse(url));
    apiFired = true;
    var data = jsonDecode(result.body);
    watchList = data['watchlists'];
    Navigator.pop(context);
    print(data);
    setState(() {
      
    });
  }
}