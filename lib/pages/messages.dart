import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget{
  final List messages;
  const Messages({Key? key, required this.messages}):super(key:key);

  @override
  _MessagesState createState() => _MessagesState();

}
class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context){
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: widget.messages[index]['isUserMessage']
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            20,
                          ),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(
                              widget.messages[index]['isUserMessage'] ? 0 : 20),
                          topLeft: Radius.circular(
                              widget.messages[index]['isUserMessage'] ? 20 : 0),
                        ),
                        color: widget.messages[index]['isUserMessage']
                            ? Colors.green.shade800
                            : Colors.pink.shade800.withOpacity(0.8)),
                    constraints: BoxConstraints(maxWidth: w * 2 / 3),
                    child:
                        Text(widget.messages[index]['message'].text.text[0], style: TextStyle(color: Colors.white),)),
              ],
            ),
          );
        },
        separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: widget.messages.length);
  }
}