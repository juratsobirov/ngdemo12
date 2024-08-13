import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../models/post_res_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isLoading = false;
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerBody = TextEditingController();

  _createPost(){
    String title = _controllerTitle.text.toString().trim();
    String body = _controllerBody.text.toString().trim();
    Post post = Post(userId:1, title: title, body: body);
    _apiCreatePost(post);
  }

  _apiCreatePost(Post post) async {

    setState((){
      isLoading = true;
    });
    var response = await Network.POST(Network.API_POST_CREATE, Network.paramsCreate(post));
    LogService.i(response!);
    PostRes postRes = Network.parsePostRes(response!);

    setState((){
      isLoading = true;
    });
    backToFinish();
  }

  backToFinish(){
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title:Text("Create Page"),
      ),
      body:Container(
        width:double.infinity,
        padding:EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                TextField(
                  controller: _controllerTitle,
                  decoration:InputDecoration(
                    hintText: "Input title",
                  ),
                ),

                TextField(
                  controller: _controllerBody,
                  decoration:InputDecoration(
                    hintText:"Input body",
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top:10),
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed:(){
                      _createPost();
                    },
                    color: Colors.blue,
                    child:Text("Save Post"),
                  ),
                )
              ],
            ),
            isLoading ? Center(child:CircularProgressIndicator(),) : SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
