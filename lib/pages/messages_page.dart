import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.12),
        child: FloatingActionButton(onPressed: () {  },
          backgroundColor: Theme.of(context).primaryColor,
          child: Image.asset('assets/icons/edit_icon.png',color: Theme.of(context).scaffoldBackgroundColor,scale: 1.5,),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Share ideas with\n your friends",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 18),
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50)),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: "Search by name or email address",
                    hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){},
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                        child: const Icon(
                          Icons.people_alt,
                          color: Colors.white,
                        )),
                  ),
                  title:const Text('Sync contacts', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}