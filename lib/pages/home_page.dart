import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ngdemo12/models/post_res_model.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import 'create_page.dart';

class _HomePageState extends State<HomePage> {
  // https://jsonplaceholder.typicode.com/posts
  bool isLoading = false;
  String resultData = "no data";
  List<Post> items = [];



  _testPostsApi() async {
    var url = Uri.https('jsonplaceholder.typicode.com', 'posts');
    var response = await http.get(url);
    LogService.i(response.body);
  }

  _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    LogService.i(response!);
    List<Post> posts = Network.parsePostList(response!);

    setState(() {
      // resultData = response;
      items = posts;
      isLoading = false;
    });
  }

  // Create Function....
  // _apiCreatePost() async {
  //   Post postC = Post(title: "Nextgen", body: "Academy", userId: 100);
  //   var response = await Network.POST(
  //       Network.API_POST_CREATE, Network.paramsCreate(postC));
  //   PostRes postRes = Network.parsePostRes(response!);
  //   LogService.i(postRes.toJson().toString());
  // setState(() {
  // resultData = response;
  // });
  // }


  _apiUpdatePost() async {
    Post postU =
        Post(id: 1, title: "Haad", body: "Learning Center", userId: 103);
    var response = await Network.PUT(
        Network.API_POST_UPDATE + postU.id.toString(),
        Network.paramsUpdate(postU));
    LogService.i(response!);
    setState(() {
      resultData = response;
    });
  }

  _apiDeletePost() async {
    Post postD = Post(id: 1);
    var response = await Network.DELETE(
        Network.API_POST_DELETE + postD.id.toString(), Network.paramsEmpty());
    LogService.i(response!);
    setState(() {
      resultData = response;
    });
  }

  _callCreatePage() async{
   bool result = await Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
      return CreatePage();
    }));

   if(result){
     _apiPostList();
   }
  }

  Future<void> _handleRefresh() async{
    _apiPostList();
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
    // _apiCreatePost();
    // _apiUpdatePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Post API"),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return itemOfPost(items[index]);
              },
            ),

            onRefresh: _handleRefresh,
          ),

          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _callCreatePage();
        },
        backgroundColor: Colors.blue,
        child:Icon(Icons.add, color:Colors.white,),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title!.toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Text(
            post.body!,
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
